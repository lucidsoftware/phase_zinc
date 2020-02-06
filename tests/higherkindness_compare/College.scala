package com.phase_zinc.tests.higherkindness_compare

class College {
  def name = "University of Michigan"
  def listOfCourses = List("Operating System", "Data Structure")
  def listOfProfessors = List("Jack", "Luke")
  def listOfCredits = List(3, 4)

  def courses = {
    val min = List(listOfCourses, listOfProfessors, listOfCredits).map(_.size).min
    (0 until min) map { i => new Course(listOfCourses(i), listOfProfessors(i), listOfCredits(i)) }
  }
}
