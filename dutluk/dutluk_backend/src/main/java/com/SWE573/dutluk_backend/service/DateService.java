package com.SWE573.dutluk_backend.service;

import com.SWE573.dutluk_backend.model.Story;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

@Service
public class DateService {

    public static String dateToStringBasedOnFlags(Date date, Integer hourFlag, Integer dateFlag) {
        if(date == null){
            return null;
        }

        SimpleDateFormat formatter;

        if (hourFlag == null || hourFlag == -1 || hourFlag == 1) {
            formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        } else {
            if(dateFlag == null){
                formatter = new SimpleDateFormat("dd/MM/yyyy");
            }
            else{
                if(dateFlag == 1){
                    formatter = new SimpleDateFormat("yyyy");
                }
                else if (dateFlag == 2) {
                    formatter = new SimpleDateFormat("MM/yyyy");
                }
                else{
                    formatter = new SimpleDateFormat("dd/MM/yyyy");
                }
            }


        }

        formatter.setTimeZone(TimeZone.getTimeZone("Europe/Istanbul"));

        return formatter.format(date);
    }

    public static Date incrementDateByOneYear(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.YEAR, 1);
        return calendar.getTime();
    }

    public static Date incrementDateByOneMonth(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.MONTH, 1);
        return calendar.getTime();
    }

    public static Date incrementDateByOneDay(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DATE, 1);
        return calendar.getTime();
    }

    public static Date convertToStartDate(String decadeString) throws ParseException {

        int decade = Integer.parseInt(decadeString.substring(0, 4));
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.YEAR, decade);
        calendar.set(Calendar.MONTH, Calendar.JANUARY);
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);

        return calendar.getTime();
    }

    public static Date convertToEndDate(String decadeString) throws ParseException {

        int decade = Integer.parseInt(decadeString.substring(0, 4));
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.YEAR, decade);
        calendar.set(Calendar.MONTH, Calendar.DECEMBER);
        calendar.set(Calendar.DAY_OF_MONTH, 31);
        calendar.set(Calendar.HOUR_OF_DAY, 23);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 0);
        calendar.add(Calendar.YEAR,9);

        return calendar.getTime();
    }

    public static Date stringToDate(String timeStamp) throws ParseException {

        if (timeStamp.length() == 4) { // yyyy
            timeStamp += "-01-01";
        } else if (timeStamp.length() == 7) { // yyyy-MM
            timeStamp += "-01";
        }
        // yyyy-MM-dd format will remain unchanged
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        return dateFormat.parse(timeStamp);
    }

    public static String timeAgo(Date date) {
        ZoneId istanbulZone = ZoneId.of("Europe/Istanbul");
        LocalDateTime now = LocalDateTime.now(istanbulZone);
        LocalDateTime createdAt = LocalDateTime.ofInstant(date.toInstant(), istanbulZone);

        long years = ChronoUnit.YEARS.between(createdAt, now);
        long months = ChronoUnit.MONTHS.between(createdAt, now);
        long days = ChronoUnit.DAYS.between(createdAt, now);
        long hours = ChronoUnit.HOURS.between(createdAt, now);
        long minutes = ChronoUnit.MINUTES.between(createdAt, now);

        if (years > 0) return years + " years ago";
        else if (months > 0) return months + " months ago";
        else if (days > 0) return days + " days ago";
        else if (hours > 0) return hours + " hours ago";
        else if (minutes > 0) return minutes + " minutes ago";
        else return "just now";
    }

    public static String getDecadeStringByStartTimeStamp(Story story) {
        Calendar calendar = Calendar.getInstance();
        if(story.getDecade() == null && story.getStartTimeStamp() != null){
            calendar.setTime(story.getStartTimeStamp());
            int year = calendar.get(Calendar.YEAR);
            int decadeStart = year - (year % 10);
            return decadeStart + "s";
        }
        return story.getDecade();
    }

    public static String getEndDecadeStringByEndTimeStamp(Story story) {
        Calendar calendar = Calendar.getInstance();
        if(story.getEndDecade() == null && story.getEndTimeStamp() != null){
            calendar.setTime(story.getEndTimeStamp());
            int year = calendar.get(Calendar.YEAR);
            int decadeStart = year - (year % 10);
            return decadeStart + "s";
        }
        return story.getEndDecade();
    }
}
