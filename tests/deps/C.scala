package com.phase_zinc.tests.deps

class C {
  def name = "Charlie"
  def threeNames = {
    val b = new B
    s"${b.twoNames} $name"
  }
}
