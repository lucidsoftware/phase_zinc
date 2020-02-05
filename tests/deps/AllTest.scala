package com.phase_zinc.tests.deps

import org.scalatest._

class AllTest extends FlatSpec {
  "deps" should "contain deps" in {
    val a = new A
    val b = new B
    val c = new C
    assert(a.name == "Alpha")
    assert(b.twoNames == "Alpha Bravo")
    assert(c.threeNames == "Alpha Bravo Charlie")
  }
}
