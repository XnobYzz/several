#include <iostream>
#include <iomanip>
using namespace std;
int main(){
    cout << "thuc hien phep tinh hang chuc";
    cout << endl;
    int x, y;
    cout << "nhap s1: ";
    cin >> x;
    cout << "nhap s2: ";
    cin >> y;
    cout << "  " << x << endl;
    cout << "x " << y << endl;
    cout << "----" << endl;
    int a1 = y % 10;
    int a2 = y / 10;
    int b1 = x * a1;
    int b2 = x * a2;
    cout << setw(4) << b1 << endl;
    cout << setw(3) << b2 << endl;
    int result = b1 + (b2 * 10);
    cout << "----" << endl;
    cout << setw(4) << result << endl;

    return 0;
}
