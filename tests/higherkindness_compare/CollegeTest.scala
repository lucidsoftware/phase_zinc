package com.phase_zinc.tests.higherkindness_compare

import org.scalatest._
import org.joda.time.{ DateTime, DateTimeZone }
import org.joda.time.format.DateTimeFormat

class CollegeTest extends FlatSpec {
  "college" should "have course" in {
    val college = new College
    val courses = college.courses

    val DATE_TIME_PATTERN = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm:ssZ")
    val time = DateTime.parse("2016-02-23T18:24:00Z", DATE_TIME_PATTERN).withZone(DateTimeZone.UTC)

    assert(courses.size == 2)
    assert(courses(0).display == "Jack teaches Operating System with 3 credits")
  }
}
