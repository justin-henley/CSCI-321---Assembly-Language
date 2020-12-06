//  Project description:  A binary calculator to convert between binary and decimal base, and add two binary numbers
//  Your Name:  Justin Henley, jahenley@mail.fhsu.edu
//  Date: 2020-08-22

#include <iostream>
#include <string>
#include <cassert>
#include <bitset>

using namespace std;

int binary_to_decimal(string s);
// precondition: s is a string that consists of only 0s and 1s
// postcondition: the positive decimal integer that is represented by s

string decimal_to_binary(int n);
// precondition: n is a positive integer
// postcondition: n’s binary representation is returned as a string of 0s and 1s

string add_binaries(string b1, string b2);
// precondition: b1 and b2 are strings that consists of 0s and 1s, i.e.
//               b1 and b2 are binary representations of two positive integers
// postcondition: the sum of b1 and b2 is returned. For instance,
//  if b1 = “11”, b2 = “01”, then the return value is “100”

string trim_leading_zeros(string s);
// precondition: s is a string that consists of only 0's and 1's
//               s represents a positive non-zero binary number
// postcondition: returns the binary number represented by s without any leading zeros

void menu();
// display the menu. Student shall not modify this function

int grade();
// returns an integer that represents the student’s grade of this projects.
// Student shall NOT modify

bool is_binary(string b);
// returns true if the given string s consists of only 0s and 1s; false otherwise

bool test_binary_to_decimal();
// returns true if the student’s implementation of binary_to_decimal function
// is correct; false otherwise. Student shall not modify this function

bool test_decimal_to_binary();
//  returns true if the student’s implementation of decimal_to_binary function is correct; false otherwise. Student shall not modify this function

bool test_add_binaries();
// which returns true if the student’s implementation of add_binaries function
// is correct; false otherwise. Student shall not modify this function


int main()
{
    int choice;
    string b1, b2;
    int x, score;
    do{
        // display menu
        menu();
        cout << "Enter you choice: ";
        cin >> choice;
        // based on choice to perform tasks
        switch(choice){
            case 1:
                cout << "Enter a binary string: ";
                cin >> b1;
                if(!is_binary(b1))
                    cout << "It is not a binary number\n";
                else
                    cout << "Its decimal value is: " << binary_to_decimal(b1) << endl;
                break;

            case 2:
                cout << "Enter a positive integer: ";
                cin >> x;
                if(x <= 0)
                    cout << "It is not a positive integer" << endl;
                else
                    cout << "Its binary representation is: " <<decimal_to_binary(x) << endl;
                break;

            case 3:
                cout << "Enter two binary numbers, separated by white space: ";
                cin >> b1 >> b2;
                if(!is_binary(b1) || !is_binary(b2))
                    cout << "At least one number is not a binary" << endl;
                else
                    cout << "The sum is: " << add_binaries(b1, b2) << endl;
                break;

            case 4:
                score = grade();
                cout << "If you turn in your project on blackboard now, you will get " << score << " out of 10" << endl;
                cout << "Your instructor will decide if one-two more points will be added or not based on your program style, such as good commnets (1 points) and good efficiency (1 point)" << endl;
                break;

            case 5:
                cout << "Thanks for using binary calculator program. Good-bye" << endl;
                break;
            default:
                cout << "Wrong choice. Please choose 1-5 from menu" << endl;
                break;
        }

    }while(choice != 5);
    return 0;
}

int binary_to_decimal(string s){
    // Convert string to bitset
    bitset<32> binaryNum(s);

    // Convert to long integer
    unsigned long longNum = binaryNum.to_ulong();

    // Cast the unsigned long to an integer
    /* This cast assumes that no binary value will be entered that exceeds the capacity of a 4-byte int,
        which is in line with the fact that the function only returns an int */
    return static_cast<int>(longNum);
}

string decimal_to_binary(int n){
    // Special case where n == 0
    if (n == 0)
        return "0";

    // Convert int to bitset
    // As the project and tests make no mention of negative numbers, the implicit cast from int to unsigned long is assumed safe
    bitset<32> binaryNum(n);

    // Convert bitset to string
    string stringNum = binaryNum.to_string();

    // Trim leading zeros
    string trimString = trim_leading_zeros(stringNum);

    return trimString; // Return the binary string trimmed to only the significant digits
}

string add_binaries(string b1, string b2){
    // Convert strings to bitsets
    // Since no maximum value is implied by a return int type here, the maximum value of unsigned long long is used
    //    to match the maximum value convertible by bitset
    bitset<64> bit1(b1), bit2(b2), bitSum;

    // Add the two values
    bitSum = bit1.to_ullong() + bit2.to_ullong();

    // Special case where the sum equals 0
    if (bitSum.to_ullong() == 0)
        return "0";

    // Convert to string and trim leading zeros
    string trimString = trim_leading_zeros(bitSum.to_string());

    return trimString;
}

string trim_leading_zeros(string s){
    // Create a new string to hold the trimmed binary number
    string trimString;
    string::iterator it = s.begin();
    while (*it == '0') // Ignores leading zeros
        it++;
    while (it != s.end()) {  // Appends significant digits to trimString
        trimString += (*it);
        it++;
    }

    // Return the binary string trimmed to only the significant digits
    return trimString;
}

void menu()
{
    cout << "******************************\n";
    cout << "*          Menu              *\n";
    cout << "* 1. Binary to Decimal       *\n";
    cout << "* 2. Decinal to Binary       *\n";
    cout << "* 3. Add two Binaries        *\n";
    cout << "* 4. Grade                   *\n";
    cout << "* 5. Quit                    *\n";
    cout << "******************************\n";
}

int grade(){
    int result = 0;
    // binary_to_decimal function worth 3 points
    if(test_binary_to_decimal()){
        cout << "binary_to_decimal function pass the test" << endl;
        result += 3;
    }
    else
        cout << "binary_to_decimal function failed" << endl;

    // decinal_to_binary function worth 2 points
    if(test_decimal_to_binary()){
        cout << "decimal_to_binary function pass the test" << endl;
        result += 2;
    }
    else
        cout << "decimal_to_binary function failed" << endl;
    // add_binaries function worth 3 points
    if(test_add_binaries()){
        cout << "add_binaries function pass the test" << endl;
        result += 3;
    }
    else
        cout << "add_binaries function pass failed" << endl;
    return result;
}

bool is_binary(string s){
    for(int i = 0; i < s.length(); i++)
        if(s[i] != '0' && s[i] != '1') // one element in s is not '0' or '1'
            return false;  // then it is not a binary nunber representation
    return true;
}

bool test_binary_to_decimal(){
    if(binary_to_decimal("0") != 0 || binary_to_decimal("1") != 1)
        return false;
    if(binary_to_decimal("010") != 2 || binary_to_decimal("10") != 2)
        return false;
    if(binary_to_decimal("01101") != 13 || binary_to_decimal("1101") != 13)
        return false;
    return true;
}

bool test_decimal_to_binary(){
    if(decimal_to_binary(0) != "0" || decimal_to_binary(1) != "1")
        return false;
    if(decimal_to_binary(2) != "10" || decimal_to_binary(13) != "1101")
        return false;
    return true;
}

bool test_add_binaries(){
    if(add_binaries("0", "0") != "0") return false;
    if(add_binaries("0", "110101") != "110101") return false;
    if(add_binaries("1", "110111") != "111000") return false;
    if(add_binaries("101", "111011") != "1000000") return false;
    return true;
}