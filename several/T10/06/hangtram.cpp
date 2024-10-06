#include <iostream>
#include <iomanip>  
using namespace std;
int main(){
    cout << "thuc hien phep tinh nhan theo hang tram" << endl;
    int x, y;
    cout << "nhap s1: ";
    cin >> x;
    cout << "nhap s2: ";
    cin >> y;
    cout << "  " << x << endl;
    cout << "x" << endl;
    cout << "  " << y << endl;
    cout << "-------" << endl;
    int hang_dv = y % 10;    
    int hang_chuc = (y / 10) % 10;
    int hang_tram = y / 100; 
    int b1 = x * hang_dv;   
    int b2 = x * hang_chuc;  
    int b3 = x * hang_tram;
    cout << setw(5) << b1 << endl; 
    cout << setw(4) << b2 << " " << endl; 
    cout << setw(3) << b3 << "  " << endl; 
    int tong = b1 + (b2 * 10) + (b3 * 100); 
    cout << "-------" << endl;
    cout << setw(4) << tong << endl;

    return 0;
}
