void main(){
  Employee employee=Employee();
  employee.showAge();
}
class Person{

  showName(){}
  showAge(){}
  showAddress(){}

}

class Profession{

  showProfession(){}
  showSalary(){}

}


class Employee implements Person ,Profession{
  showName(){
    print('mohammed');
  }
  showAge(){
    print('21');
  }
  showAddress(){
    print('cairo');
  }
  showProfession(){
    print('engineer');
  }
  showSalary(){
    print('1000');
  }

}