package com.SWE573.dutluk_backend.service;

import org.junit.jupiter.api.Test;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;

import static org.junit.jupiter.api.Assertions.assertEquals;

    class DateServiceTest {

        @Test
        void dateToStringBasedOnFlags() {
            DateService dateService = new DateService();
            Calendar calendar = Calendar.getInstance();
            calendar.set(2023, Calendar.JANUARY, 1, 15, 30);
            Date date = calendar.getTime();

            String resultFull = dateService.dateToStringBasedOnFlags(date, 1, null);
            String expectedResultFull = "01/01/2023 15:30";
            assertEquals(expectedResultFull, resultFull);

            String resultDateOnly = dateService.dateToStringBasedOnFlags(date, 0, null);
            String expectedResultDateOnly = "01/01/2023";
            assertEquals(expectedResultDateOnly, resultDateOnly);

            String resultYearOnly = dateService.dateToStringBasedOnFlags(date, 0, 1);
            String expectedResultYearOnly = "2023";
            assertEquals(expectedResultYearOnly, resultYearOnly);
        }

        @Test
        void incrementDateByOneYear() {
            DateService dateService = new DateService();
            Calendar calendar = Calendar.getInstance();
            calendar.set(2023, Calendar.JANUARY, 1);
            Date date = calendar.getTime();

            Date incrementedDate = dateService.incrementDateByOneYear(date);

            calendar.add(Calendar.YEAR, 1);
            Date expectedDate = calendar.getTime();

            assertEquals(expectedDate, incrementedDate);
        }

        @Test
        void incrementDateByOneMonth() {
            DateService dateService = new DateService();
            Calendar calendar = Calendar.getInstance();
            calendar.set(2023, Calendar.JANUARY, 1);
            Date date = calendar.getTime();

            Date incrementedDate = dateService.incrementDateByOneMonth(date);

            calendar.add(Calendar.MONTH, 1);
            Date expectedDate = calendar.getTime();

            assertEquals(expectedDate, incrementedDate);
        }

        @Test
        void incrementDateByOneDay() {
            DateService dateService = new DateService();
            Calendar calendar = Calendar.getInstance();
            calendar.set(2023, Calendar.JANUARY, 1);
            Date date = calendar.getTime();

            Date incrementedDate = dateService.incrementDateByOneDay(date);

            calendar.add(Calendar.DATE, 1);
            Date expectedDate = calendar.getTime();

            assertEquals(expectedDate, incrementedDate);
        }

        @Test
        void convertToStartDate() throws ParseException {
            DateService dateService = new DateService();
            Date result = dateService.convertToStartDate("2020");

            Calendar calendar = Calendar.getInstance();
            calendar.set(2020, Calendar.JANUARY, 1, 0, 0, 0);
            calendar.set(Calendar.MILLISECOND, 0);

            Date expectedDate = calendar.getTime();

            assertEquals(expectedDate, result);
        }

        @Test
        void convertToEndDate() throws ParseException {
            DateService dateService = new DateService();
            Date result = dateService.convertToEndDate("2020");

            Calendar calendar = Calendar.getInstance();
            calendar.set(2029, Calendar.DECEMBER, 31, 23, 59, 59);
            calendar.set(Calendar.MILLISECOND, 0);

            Date expectedDate = calendar.getTime();

            assertEquals(expectedDate, result);
        }

        @Test
        void stringToDate() throws ParseException {
            DateService dateService = new DateService();
            String inputDate = "2023-01-01";

            Date result = dateService.stringToDate(inputDate);

            Calendar calendar = Calendar.getInstance();
            calendar.set(2023, Calendar.JANUARY, 1, 0, 0, 0);
            calendar.set(Calendar.MILLISECOND, 0);

            Date expectedDate = calendar.getTime();

            assertEquals(expectedDate, result);
        }

        @Test
        void timeAgo() {
            DateService dateService = new DateService();
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MINUTE, -30); // 30 minutes ago
            Date date = calendar.getTime();

            String result = dateService.timeAgo(date);

            assertEquals("30 minutes ago", result);
        }

    }


