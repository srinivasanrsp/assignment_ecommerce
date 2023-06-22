void main() {}

mixin C {
  int? reuse;
}

class A {
  int? property;
}

class B extends A with C {

}
