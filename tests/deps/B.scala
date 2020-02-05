package com.phase_zinc.tests.deps

class B {
  def name = "Bravo"
  def twoNames = {
    val a = new A
    s"${a.name} $name"
  }
}
