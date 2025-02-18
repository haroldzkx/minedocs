# 【运算符重载】

运算符重载概念：对已有的运算符重新进行定义，赋予其另一种功能，以适应不同的数据类型

<details>
<summary>1.加号运算符重载</summary>

```cpp
/** 作用：实现两个自定义数据类型相加的运算 */
class Person{
public:
    //1.成员函数重载+号
    Person operator+(Person &p){
        Person temp;
        temp.m_a = this->m_a + p.m_a;
        temp.m_b = this->m_b + p.m_b;
        return temp;
    }
    int m_a;
    int m_b;
};
//2.全局函数重载+号
Person operator+(Person &p1, Person &p2){
    Person temp;
    temp.m_a = p1.m_a + p2.m_a;
    temp.m_b = p1.m_b + p2.m_b;
    return temp;
}
//3.函数重载的运算符重载
Person operator+(Person &p1, int num){
    Person temp;
    temp.m_a = p1.m_a + num;
    temp.m_b = p1.m_b + num;
    return temp;
}
void test01(){
    Person p1;
    p1.m_a = 10;
    p1.m_b = 10;
    Person p2;
    p2.m_a = 10;
    p2.m_b = 10;
    //成员函数重载+号 本质调用 Person p3 = p1.operator+(p2)
    //全局函数重载+号 本质调用 Person p3 = operator+(p1, p2)
    Person p3 = p1 + p2;
    //运算符重载，也可以发生函数重载
    Person p4 = p1 + 100;
    cout << "p3.m_a = " << p3.m_a << endl;
    cout << "p3.m_b = " << p3.m_b << endl;
    cout << "p4.m_a = " << p4.m_a << endl;
    cout << "p4.m_b = " << p4.m_b << endl;
}
```

</details>

<details>
<summary>2.左移运算符重载</summary>

```cpp
/** 作用：可以输出自定义数据类型 */
/** 总结：重载左移运算符配合友元可以实现输出自定义数据类型。*/
class Person{
    friend ostream & operator<<(ostream &cout, Person &p);
public:
    Person(int a, int b)
        :m_a(a), m_b(b){}
private:
    //利用成员函数重载 左移运算符 p.operator<<(cout) 简化版本 p << cout
    //因此不会利用成员函数重载<<运算符，因为无法实现cout在左侧
    //void operator<<(Person &p){}
    int m_a;
    int m_b;
};
//只能利用全局函数重载左移运算符
//本质 operator<<(cout, p) 简化 cout << p
ostream& operator<<(ostream &cout, Person &p){
    cout << "m_a = " << p.m_a << ", m_b = " << p.m_b << endl;
    return cout;
}
void test01(){
    Person p(10, 10);
    cout << p << endl;
}
```

</details>

<details>
<summary>3.递增运算符重载</summary>

前置递增【 MyInteger& operator++() 】返回引用

后置递增【 MyInteger operator++(int) 】返回值

```cpp
/** 作用：通过重载递增运算符，实现自己的整型数据 */
class MyInteger{
    friend ostream& operator<<(ostream &cout, MyInteger myint);
public:
    MyInteger(){
        m_num = 0;
    }
    //重载前置++运算符 返回引用为了一直对一个数据进行递增操作
    MyInteger& operator++(){
        m_num++;    //先进行++运算
        return *this;  //再将自身做返回
    }
    //重载后置++运算符，返回值，不是返回引用
    //operator++(int) int代表占位参数，可以用于区分前置和后置递增
    MyInteger operator++(int){
        MyInteger temp = *this;  //先 记录当时结果
        m_num++;        //后 递增
        return temp;      //再将自身做返回
    }
private:
    int m_num;
};
//重载<<运算符
ostream& operator<<(ostream &cout, MyInteger myint){
    cout << myint.m_num;
    return cout;
}
void test01(){
    MyInteger myint;
    cout << ++myint << endl;
    cout << myint << endl;
    cout << myint++ << endl;
    cout << myint << endl;
}
```

</details>

<details>
<summary>4.赋值运算符重载</summary>

C++编译器至少给一个类添加 4 个函数

1. 默认构造函数（无参，函数体为空）
2. 默认析构函数（无参，函数体为空）
3. 默认拷贝构造函数，对属性进行值拷贝
4. 赋值运算符 operator=，对属性进行值拷贝

如果类中有属性指向堆区，做赋值操作时也会出现深浅拷贝问题

```cpp
class Person{
public:
    Person(int age){
        m_age = new int(age);
    }
    ~Person(int age){
        if( m_age != NULL){
            delete m_age;//释放内存
            m_age = NULL;//防止野指针出现，进行置空操作
        }
    }
    //重载 赋值运算符
    Person& operator=(Person &p){
    //编译器是提供浅拷贝
        //m_age = p.m_age;
        //应该先判断是否有属性在堆区
        //如果有先释放干净，然后再深拷贝
        if(m_age != NULL){
            delete m_age;
            m_age = NULL:
        }
        //深拷贝
        m_age = new int( *p.m_age );
        //返回对象本身
        return *this;
    }
    int* m_age;
};
void test01(){
    Person p1(18);
    Person p1(20);
    Person p3(30)
    p3 = p2 = p1;
    cout << "p1 age is " << *p1.m_age << endl;
    cout << "p2 age is " << *p2.m_age << endl;
    cout << "p3 age is " << *p3.m_age << endl;
}
```

</details>

<details>
<summary>5.关系运算符重载</summary>

```cpp
/** 作用：重载关系运算符，可以让两个自定义类型对象进行对比操作 */
class Person{
public:
    Person(string name, int age){
        this->m_name = name;
        this->m_age = age;
    }
    //重载 == 号
    bool operator==(Person &p){
        if(this->m_name == p.m_name && this->m_age == p.m_age){
            return true;
        }
        return false;
    }
    //重载 != 号
    bool operator!=(Person &p){
        if(this->m_name == p.m_name && this->m_age == p.m_age){
            return false;
        }
        return true;
    }
    string name;
    int age;
};
void test01(){
    Person p1("TOM", 18);
    Person p2("TOM", 18);
    Person p3("JACK", 18);
    if(p1 == p2){
        cout << "p1 == p2" << endl;
    }else{
        cout << "p1 != p2" << endl;
    }
    if(p1 != p3){
        cout << "p1 != p3" << endl;
    }else{
        cout << "p1 == p3" << endl;
    }
}
```

</details>

<details>
<summary>6.函数调用运算符重载</summary>

- 函数调用运算符（）也可以重载
- 由于重载后使用的方式非常像函数的调用，因此成为仿函数
- 仿函数没有固定写法，非常灵活

```cpp
class MyPrint{
public:
    //重载函数调用运算符
    void operator()(string test){
        cout << test << endl;
    }
};
void MyPrint02(string test){
    cout << test << endl;
}
void test01(){
    MyPrint myPrint;
    myPrint("hello world");    //仿函数
    myPrint02("hello world");  //真正的函数调用
}

//仿函数非常灵活，没有固定的写法
//加法类
class MyAdd{
public:
    int operator()(int num1, int num2){
        return num1 + num2;
    }
};
void test02(){
    MyAdd myAdd;
    int ret = myAdd(100, 100);
    cout << "ret = " << ret << endl;
    //匿名函数对象
    cout << MyAdd()(100, 100) << endl;
}
```

</details>
