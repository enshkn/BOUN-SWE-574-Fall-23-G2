package com.SWE573.dutluk_backend.service;

import org.junit.jupiter.api.Test;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

import static org.junit.jupiter.api.Assertions.assertEquals;

    class DateServiceTest {

        @Test
        void dateToStringBasedOnFlags() {
            Calendar calendar = Calendar.getInstance();
            calendar.set(2023, Calendar.JANUARY, 1, 15, 30);


            TimeZone tz = TimeZone.getTimeZone("Europe/Istanbul");
            calendar.setTimeZone(tz);


            Date date = calendar.getTime();

            String resultFull = DateService.dateToStringBasedOnFlags(date, 1, 3);
            String expectedResultFull = "01/01/2023 15:30";
            assertEquals(expectedResultFull, resultFull);

            String resultDateOnly = DateService.dateToStringBasedOnFlags(date, 0, 3);
            String expectedResultDateOnly = "01/01/2023";
            assertEquals(expectedResultDateOnly, resultDateOnly);

            String resultYearOnly = DateService.dateToStringBasedOnFlags(date, 0, 1);
            String expectedResultYearOnly = "2023";
            assertEquals(expectedResultYearOnly, resultYearOnly);
        }

        @Test
        void incrementDateByOneYear() {
            Calendar calendar = Calendar.getInstance();
            calendar.set(2023, Calendar.JANUARY, 1);
            Date date = calendar.getTime();

            Date incrementedDate = DateService.incrementDateByOneYear(date);

            calendar.add(Calendar.YEAR, 1);
            Date expectedDate = calendar.getTime();

            assertEquals(expectedDate, incrementedDate);
        }

        @Test
        void incrementDateByOneMonth() {
            Calendar calendar = Calendar.getInstance();
            calendar.set(2023, Calendar.JANUARY, 1);
            Date date = calendar.getTime();

            Date incrementedDate = DateService.incrementDateByOneMonth(date);

            calendar.add(Calendar.MONTH, 1);
            Date expectedDate = calendar.getTime();

            assertEquals(expectedDate, incrementedDate);
        }

        @Test
        void incrementDateByOneDay() {
            Calendar calendar = Calendar.getInstance();
            calendar.set(2023, Calendar.JANUARY, 1);
            Date date = calendar.getTime();

            Date incrementedDate = DateService.incrementDateByOneDay(date);

            calendar.add(Calendar.DATE, 1);
            Date expectedDate = calendar.getTime();

            assertEquals(expectedDate, incrementedDate);
        }

        @Test
        void convertToStartDate() throws ParseException {
            Date result = DateService.convertToStartDate("2020");

            Calendar calendar = Calendar.getInstance();
            calendar.set(2020, Calendar.JANUARY, 1, 0, 0, 0);
            calendar.set(Calendar.MILLISECOND, 0);

            Date expectedDate = calendar.getTime();

            assertEquals(expectedDate, result);
        }

        @Test
        void convertToEndDate() throws ParseException {
            Date result = DateService.convertToEndDate("2020");

            Calendar calendar = Calendar.getInstance();
            calendar.set(2029, Calendar.DECEMBER, 31, 23, 59, 59);
            calendar.set(Calendar.MILLISECOND, 0);

            Date expectedDate = calendar.getTime();

            assertEquals(expectedDate, result);
        }

        @Test
        void stringToDate() throws ParseException {
            String inputDate = "2023-01-01";

            Date result = DateService.stringToDate(inputDate);

            Calendar calendar = Calendar.getInstance();
            calendar.set(2023, Calendar.JANUARY, 1, 0, 0, 0);
            calendar.set(Calendar.MILLISECOND, 0);

            Date expectedDate = calendar.getTime();

            assertEquals(expectedDate, result);
        }

        @Test
        void timeAgo() {
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.MINUTE, -30); // 30 minutes ago
            Date date = calendar.getTime();

            String result = DateService.timeAgo(date);

            assertEquals("30 minutes ago", result);
        }

    }


