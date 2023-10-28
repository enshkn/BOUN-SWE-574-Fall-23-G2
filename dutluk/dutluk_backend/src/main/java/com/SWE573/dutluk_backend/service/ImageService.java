package com.SWE573.dutluk_backend.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.io.IOException;
import java.util.Base64;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.core.io.ByteArrayResource;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class ImageService {
    @Value("${IMGUR_CLIENT_ID}")
    String imgurClientId;

    public String parseAndSaveImages(String textWithBase64) {
        String regex = "data:image/[^;]*;base64,([^\\\"]+)";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(textWithBase64);
        StringBuffer updatedText = new StringBuffer();

        while (matcher.find()) {
            String base64Data = matcher.group(1);
            byte[] imageBytes = Base64.getDecoder().decode(base64Data);
            String imgurUrl = uploadImageToImgur(imageBytes, imgurClientId);
            matcher.appendReplacement(updatedText, imgurUrl);
        }
        matcher.appendTail(updatedText);

        return updatedText.toString();
    }

    private String uploadImageToImgur(byte[] imageBytes, String imgurClientId) {
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        headers.set("Authorization", "Client-ID " + imgurClientId);

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("image", new ByteArrayResource(imageBytes) {
            @Override
            public String getFilename() {
                return "image.png";
            }
        });

        HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

        ResponseEntity<String> response = restTemplate.exchange(
                "https://api.imgur.com/3/image",
                HttpMethod.POST,
                requestEntity,
                String.class
        );
        String imgurUrl = extractImgurImageUrl(response.getBody());

        return imgurUrl;
    }

    private String extractImgurImageUrl(String response) {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            JsonNode rootNode = objectMapper.readTree(response);
            JsonNode dataNode = rootNode.get("data");
            String imgUrl = dataNode.get("link").asText();
            return imgUrl;
        } catch (IOException e) {
            e.printStackTrace();
            return "";
        }
    }
}
