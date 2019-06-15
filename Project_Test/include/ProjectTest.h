#ifndef PROJECT_TEST_H_
#define PROJECT_TEST_H_

#include <vector>
#include <string>

using std::vector;
using std::string;

// Declaring Extern Global Variables
typedef void (*pointerToTestsFunctions)();
extern vector<pointerToTestsFunctions> testsFunctions;
extern int green;
extern int red;
extern int tests;
extern const long MILLIS_TO_WAIT;
extern pointerToTestsFunctions currentTestFunction;
extern string currentTestName;
extern vector<vector<string>> errorLog;
extern bool testFunctionActive;

// Declaring Functions
void start();
void * InitiateFunctionInThread(void * pVoid);
void ExecuteTests();
void summery();
void test(int testId,string got, string expected,vector<string> args = vector<string>{""});
void test(int testId,float got, float expected,vector<string> args = vector<string>{""});
void test(int testId,int got, int expected,vector<string> args = vector<string>{""});
void test(int testId,unsigned int got, unsigned int expected,vector<string> args = vector<string>{""});
string GetStdoutFromCommand(string cmd);
string GetStdoutFromCommandAsync(string cmd, string endCommandString,int maxMillisToWait,int & successFlag);
string GetStdoutFromCommandInteractive(string cmd, vector<string> expect, vector<string> send,int maxMillisToWait,int & successFlag);
FILE * popenGillespie(string command, string type, int & pid);
int pcloseGillespie(FILE * fp, pid_t pid);
pid_t popenMonitor(pid_t commandPID,int millisToWait);
int pcloseMonitor(pid_t monitorPID);
void popenInteractive(string cmd, int & pid, FILE * streams[]);
int pcloseInteractive(FILE * streams[], pid_t pid);

#endif
