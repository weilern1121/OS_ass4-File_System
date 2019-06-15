// Using Code from Author: Jeremy Morgan
#define READ   0
#define WRITE  1
#define _XOPEN_SOURCE 600
#define __USE_BSD

#include <vector>
#include <string>
#include <iostream>
#include <pthread.h>
#include <chrono>
#include <thread>
#include <time.h>
#include "../include/ProjectTest.h"
#include "../include/Tests.h"
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <sys/wait.h>
#include <errno.h>
#include <sstream>
#include <chrono>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <termios.h>
#include <sys/select.h>
#include <sys/ioctl.h>

using std::vector;
using std::string;
using std::cout;
using std::clock;
using std::endl;
using std::to_string;

#define RED   "\e[38;5;196m"
#define GRN   "\e[38;5;082m"
#define YEL   "\e[38;5;226m"
#define MAG   "\e[38;5;201m"
#define ORG   "\e[38;5;202m"
#define RESET "\e[0m"

#define MAX_GOT_EXPECTED_OUTPUT 1000

// Defining Global Variables
int green = 0;
int red = 0;
int tests;
const long MILLIS_TO_WAIT = 14400000;
int timeForSmallTest = 600000;
vector<pointerToTestsFunctions> testsFunctions;
pointerToTestsFunctions currentTestFunction = 0;
string currentTestName = "NO_TEST_HAS_BEEN_SUCCESSFULLY_EXECUTED_YET";
vector<vector<string>> errorLog;
bool testFunctionActive = 0;
int testToExecute = -1;
volatile int abortExecution = 0;
int monitorAbort = 0;
static void sigintMonitorHandler(int num);
static void sigquitMonitorHandler(int num);

int main(int argc,char* argv[])
{    
    // Retrieving args
    if(argc == 2){
        // Retrieving specific test to execute
        int number;
        if((number = atoi(argv[1])) >= 0){
            testToExecute = number;
        }
    }
    
    // Starting tests
    start();

    // Initializing tests to be executed
    InitializingTests();

    // Initializing before execution of tests
    Initialize();

    // Executing tests
    ExecuteTests();

    // Finialize after execution of tests
    Finialize();
    
    // Summarizing tests
    summery();
}

// Declaring start of test
void start()
{
    // Declaring start of test
    cout << MAG << "*******************************************" << endl;
    cout << "       Start Of Operating System Test                  " << endl;
    cout << "*******************************************\n" << RESET << endl;

}

// Executing tests
void ExecuteTests()
{
    // Initializing
    int rc;

    // Executing tests
    for(unsigned int i = 0;i < testsFunctions.size();i++)
    {
      // Executing Thread
      pthread_t thread;
      currentTestFunction = testsFunctions.at(i);
      rc = pthread_create(&thread, NULL, InitiateFunctionInThread,NULL);

      // Asserting Thread Was Successfully Executed
      if (rc)
      {
        cout << "\n\n\n----------------------------\nError:unable to create thread"
             << "\n----------------------------\n\n\n" << rc << endl;

        continue;
      }

      // Waiting For Thread To Finish  -->

      //Retrieving Current Time For Timeout
      std::this_thread::sleep_for(std::chrono::milliseconds(200));
      auto t_start = std::chrono::high_resolution_clock::now();

      // Waiting For Current Test To Finish Unless Timeout
      while (testFunctionActive == 1)
      {
        // Retrieving Current Time For Timeout
        auto t_end = std::chrono::high_resolution_clock::now();

        // Calculating Current Test Duration
        float duration = std::chrono::duration<double, std::milli>(t_end-t_start).count();

        // Asserting Test Duration Did Not Pass Limit
        if(duration > MILLIS_TO_WAIT)
        {
          // Canceling Thread
          pthread_cancel(thread);

          // Waiting for thread to terminate
          pthread_join(thread,NULL);

          // Declaring Test Execution Ended With TImeout
          test(-1,"$$$ TEST EXECUTION TIMED OUT $$$","");

          // Declaring test terminated
          testFunctionActive = 0;
        }
      }
    }
      // Waiting For Thread To Finish  <--
}

void * InitiateFunctionInThread(void * pVoid)
{
    // Declaring Test Thread Active
    testFunctionActive = 1;

    // Executing Test Function
    try
    {
      currentTestFunction();
    }
    catch(const std::exception &exc)
    { 
      // Adding error to error log
      vector<string> newError;
      newError.push_back(currentTestName);
      newError.push_back(exc.what());
      errorLog.push_back(newError);

      // Declaring Exception Raised Durning Test Execution
      test(-1,"","$$$ DECLARE BAD TEST $$$");
    }

    // Declaring Test Thread No Longer Active
    testFunctionActive = 0;

    // Exiting Thread
    pthread_exit(NULL);
}

void summery()
{
    // Declaring end of test
    cout << MAG << "\n*******************************************" << endl;
    cout << "       End Of Operating System Test                    " << endl;
    cout << "*******************************************" << RESET << endl;

    // Summarizing
    cout << GRN << "Green: " <<  green << RESET <<  "," << RED << " Red: " << red << RESET << endl;

    // Printing exceptions log
    if(errorLog.size() != 0)
    {
        cout << "\nExceptions Log:\n-------------------------------------------" << endl;


        for (unsigned int i = 0;i < errorLog.size();i++)
          cout << "\n" <<  errorLog[i][0] << " exceptions log:\n" << errorLog[i][1];
    }

    cout << endl;
}

// Checking if test operated according to plan
void test(int testId,string got, string expected,vector<string> args)
{
    // Initializing
    bool testPassed = false;

    // Counting test
    tests++;

    // Calculating test results
    if(expected == "$$$ ASSERT_THROWN_EXCEPTIONS $$$")
    {
      testPassed = false;
      got = "$$$ NO EXCEPTION WAS THROWN $$$";
    }
    else if(expected == "$$$ ASSERT_NO_THROWN_EXCEPTIONS $$$" || expected == "$$$ DECLARE GOOD TEST $$$" || got == expected)
      testPassed = true;
    else if(expected == "$$$ DECLARE BAD TEST $$$")
    {
      testPassed = false;
      got = "$$$ EXCEPTION WAS THROWN $$$";
    }
    else if(expected == "$$$ TEST EXECUTION TIMED OUT $$$")
      testPassed = false;
    else if(expected == "$$$ SMALL TEST EXECUTION TIMED OUT $$$")
      testPassed = false;
    else if(expected == "$$$ TEST EXECUTION ERROR $$$")
      testPassed = false;

 // Checking if test operated according to plan
    if (testPassed == true)
    {
      // Counting good test
      green++;
    }
    else
    {
      // Counting bad test and declaring
      red++;

      // Declaring bad test
      if(got == "$$$ EXCEPTION WAS THROWN $$$"){
        cout << "\r" << RED << currentTestName <<  "(Test ID: " << testId << ")" <<
             " did not complete successfully !!!\n" << RESET;
      }
      else if(got == "$$$ TEST EXECUTION TIMED OUT $$$"){
        cout << "\r" << RED << currentTestName <<  "(Test ID: " << testId << ")" <<
             " took more than " <<  MILLIS_TO_WAIT/1000 << " seconds, therefore it has been timed out.\n"
             << RESET;
      }
      else if(got == "$$$ SMALL TEST EXECUTION TIMED OUT $$$"){
        cout << "\r" << RED << currentTestName <<  "(Test ID: " << testId << ")" <<
             " took more than " <<  timeForSmallTest/1000 << " seconds, therefore it has been timed out.\n"
             << RESET;
      }
      else if(got == "$$$ TEST EXECUTION ERROR $$$"){
        cout << "\r" << RED << currentTestName <<  "(Test ID: " << testId << ")" <<
             " ennded with fatal error, see test output for more information.\n"
             << RESET;
      }
      else if(got == "$$$ USER TERMINATED TEST $$$"){
        cout << "\r" << RED << currentTestName <<  "(Test ID: " << testId << ")" <<
             " terminated by user.\n"
             << RESET;
      }
      else if(args[0] == "String value with /n"){
        if(got.length() > MAX_GOT_EXPECTED_OUTPUT || expected.length() > MAX_GOT_EXPECTED_OUTPUT){
          got = "output too long, see test got output";
          expected = "output too long, see test expected output"; 
        }

        cout << "\r" << RED << currentTestName <<  "(Test ID: " << testId << ")" <<
             " --> Failed" << ",\n-------------------------------\ngot\n-------------------------------\n" <<
             YEL << got << RED <<
             "\n-------------------------------\nwhile expected\n-------------------------------\n" << GRN
             << expected << RED
             "\n-------------------------------\n" << RESET;
      }
      else{
        cout << "\r" << RED <<  currentTestName <<  "(Test ID: " << testId << ")" <<  " --> Failed" <<
             ", got " << YEL << got << RED << " while expected " << GRN << expected << RED << ".\n" << RESET;
      }
        
      if(got != "$$$ EXCEPTION WAS THROWN $$$" && got != "$$$ TEST EXECUTION TIMED OUT $$$" && args.size() >= 2){
          cout << ORG << "hint: " << args[1] << "\n\n" <<  RESET;
      }
    }
}

// Checking if test operated according to plan
void test(int testId,float got, float expected,vector<string> args)
{
    test(testId,to_string(got),to_string(expected),args);
}

void test(int testId,int got, int expected,vector<string> args)
{
    test(testId,to_string(got),to_string(expected),args);
}

void test(int testId,unsigned int got, unsigned int expected,vector<string> args)
{
    test(testId,to_string(got),to_string(expected),args);
}

// Retrieving Terminal Output :: Author: Jeremy Morgan
string GetStdoutFromCommand(string cmd)
{
  // Initializing
  string data;
  FILE * stream;
  const int max_buffer = 4000;
  char buffer[max_buffer];
  cmd.append(" 2>&1");
  stream = popen(cmd.c_str(), "r");
  
  // Retrieving Terminal Output
  if (stream)
  {
      while (!feof(stream))
      {
        if (fgets(buffer, max_buffer, stream) != NULL)
          data.append(buffer);
      }

      pclose(stream);
  }

  return data;
}

// Retrieving Terminal Output Async :: Author: Jeremy Morgan
string GetStdoutFromCommandAsync(string cmd, string endCommandString,int maxMillisToWait,int & successFlag)
{

  // Initializing
  string data;
  const int max_buffer = 4000;
  char buffer[max_buffer];
  FILE * stream;
  cmd.append(" 2>&1");
  pid_t commandPID;
  bool testEnded = false;
  pid_t monitorPID;
  successFlag = false;
  int monitorStatus;

  // Executing command
  stream = popenGillespie(cmd.c_str(), "r",commandPID);

  // Retrieving monitor for command
  monitorPID = popenMonitor(commandPID,maxMillisToWait);

  // Retrieving Terminal Output
  if (stream)
  {   
     while (!feof(stream))
      { 
        // Reading line of test output
        if (fgets(buffer, max_buffer, stream) != NULL){
            data.append(buffer);
            string bufferString(buffer);

            // Checking for test end condition
            if(bufferString.find(endCommandString) != string::npos){
              testEnded = true;
            }
        }

        // Ending command if needed
        if(testEnded){
          kill(-commandPID, 9);
          break;
        }
      }
  }

  // Closing stream
  pcloseGillespie(stream,commandPID);

  // Closing monitor
  monitorStatus = pcloseMonitor(monitorPID);

  // Declaring test completed or not
  if(testEnded){
    successFlag = 1;
  }
  else if(monitorStatus == 1){
    successFlag = 0;
  }
  else if(monitorStatus == 0){
    successFlag = 2;
  }
  else{
    successFlag = -1;
  }

  return data;
}

// Interacting with an interactive program
string GetStdoutFromCommandInteractive(string cmd, vector<string> expect, vector<string> send,int maxMillisToWait,int & successFlag)
{
  // Initializing
  string data;
  const int max_buffer = 4000;
  char buffer[max_buffer];
  FILE * streams[2];
  cmd.append(" 2>&1");
  pid_t commandPID;
  bool testEnded = false;
  pid_t monitorPID;
  successFlag = false;
  int monitorStatus;
  fd_set fd_in;
  int fdm;
  int fgetsError = false;
  int rc;
  uint expect_index = 0;
  uint send_index = 0;

  // Asserting expect and send are ok, i.e expect need to be larger by one from send since expect has the last phrase of the communication
  if(expect.size() != (send.size() + 1)){
    return "error in GetStdoutFromCommandInteractive: expect and send sizes or no good ==> expect: " + to_string(expect.size()) + 
           " send: " + to_string(send.size()) + "\n";
  }

  // Executing command
  popenInteractive(cmd, commandPID, streams);
  
  // Retrieving streams file descriptor for initializing purposes before start of communication
  fdm = fileno(streams[0]);

  // Retrieving monitor for command
  monitorPID = popenMonitor(commandPID,maxMillisToWait);

  // Retrieving Terminal Output
  if (fdm)
  {   
      while (!feof(streams[0]) && !fgetsError)
        { 
          // Wait for data from standard input and master side of PTY
          FD_ZERO(&fd_in);
          FD_SET(0, &fd_in);
          FD_SET(fdm, &fd_in);

          rc = select(fdm + 1, &fd_in, NULL, NULL, NULL);
          switch(rc)
          {
            case -1 : 
                      return "Error on select()\n";
                      break;
            default :
            {
              // Reading line of test output
              if (fgets(buffer, max_buffer, streams[0]) != NULL){
                  data.append(buffer);
                  string bufferString(buffer);

                  // Checking next expect phrase
                  if(bufferString.find(expect.at(expect_index)) != string::npos){
                    // Proceeding for next expect phrase
                    expect_index++;

                    // Asserting end phrase has reached
                    if(expect_index == expect.size()){
                      testEnded = true;
                      break;
                    }
                    
                    // Sending next send phrase to interactive program
                    write(fdm, send.at(send_index).c_str(),send.at(send_index).size());

                    // Proceeding for next send phrase 
                    send_index++;
                  }
              } 
              else{
                // Declaring fgets recieved an error, possible slave side of ptty closed, i.e the interactive program closed
                fgetsError = true;
                kill(-commandPID, 9);
                break;
              }  
            }
        }
        // Ending command if needed
        if(testEnded){
          kill(-commandPID, 9);
          break;
        }
      }
  }

  // Closing stream
  pcloseInteractive(streams,commandPID);

  // Closing monitor
  monitorStatus = pcloseMonitor(monitorPID);

  // Declaring test completed or not
  if(testEnded){
    successFlag = 1;
  }
  else if(monitorStatus == 1){
    successFlag = 0;
  }
  else if(monitorStatus == 0){
    successFlag = 2;
  }
  else{
    successFlag = -1;
  }

  return data;
}

// Opening an interactive programe and returning streams to communicate with it. Adapted from Author R. Koucha
void popenInteractive(string cmd, int & child_pid, FILE * streams[])
{ 
  // Initializing
  int fdm, fds;
  int rc;

  // This call creates the master side of the pty. It opens the device /dev/ptmx to get the file descriptor belonging to the master side.
  fdm = posix_openpt(O_RDWR);
  if (fdm < 0){
    cout << "Error on posix_openpt()\n";
    return;
  }

  // The file descriptor got from posix_openpt() is passed to grantpt() to change the access rights on the slave 
  // side: the user identifier of the device is set to the user identifier of the calling process. The group is 
  // set to an unspecified value (e.g. "tty") and the access rights are set to crx--w----.
  rc = grantpt(fdm);
  if (rc != 0){
    cout <<  "Error on grantpt()\n";
    return;
  }

  // After grantpt(), the file descriptor is passed to unlockpt() to unlock the slave side.
  rc = unlockpt(fdm);
  if (rc != 0){
    cout <<  "Error on unlockpt()\n";
    return;
  }

  // Open the slave side of the PTY
  fds = open(ptsname(fdm), O_RDWR);

  // Create the child process
  if ((child_pid = fork()) > 0){ 
    // FATHER

    // Close the slave side of the PTY
    close(fds);

    // Creating file streams for writing and reading from slave side of ptty
    streams[0] = fdopen(fdm, "r");
    streams[1] = fdopen(fdm, "w");
    return;
  }
  else{
    setpgid(child_pid, child_pid); //Needed so negative PIDs can kill children of /bin/sh

    struct termios slave_orig_term_settings; // Saved terminal settings
    struct termios new_term_settings; // Current terminal settings

    // CHILD

    // Close the master side of the PTY
    close(fdm);

    // Save the defaults parameters of the slave side of the PTY
    rc = tcgetattr(fds, &slave_orig_term_settings);

    // Set RAW mode on slave side of PTY
    new_term_settings = slave_orig_term_settings;
    cfmakeraw (&new_term_settings);
    tcsetattr (fds, TCSANOW, &new_term_settings);

    // The slave side of the PTY becomes the standard input and outputs of the child process
    close(0); // Close standard input (current terminal)
    close(1); // Close standard output (current terminal)
    close(2); // Close standard error (current terminal)

    dup(fds); // PTY becomes standard input (0)
    dup(fds); // PTY becomes standard output (1)
    dup(fds); // PTY becomes standard error (2)

    // Now the original file descriptor is useless
    close(fds);

    // Make the current process a new session leader
    setsid();

    // As the child is a session leader, set the controlling terminal to be the slave side of the PTY
    // (Mandatory for programs like the shell to make them manage correctly their outputs)
    ioctl(0, TIOCSCTTY, 1);

    execl("/bin/sh", "/bin/sh", "-c", cmd.c_str(), NULL);
    exit(1);
  }

  return;
} 

// Closing interactive program communication
int pcloseInteractive(FILE * streams[], pid_t pid)
{   
    // Initializing
    int stat;

    // Closing master side ptty streams
    fclose(streams[0]);
    fclose(streams[1]);

    // Waiting for interactive program to close
    while (waitpid(pid, &stat, 0) == -1)
    {
        if (errno != EINTR)
        {
            stat = -1;
            break;
        }
    }

    return stat;
}

// Gillespie code for popen with pid extract
FILE * popenGillespie(string command, string type, int & pid)
{
    pid_t child_pid;
    int fd[2];
    pipe(fd);

    if((child_pid = fork()) == -1)
    {
        perror("fork");
        exit(1);
    }

    /* child process */
    if (child_pid == 0)
    {
        if (type == "r")
        {
            close(fd[READ]);    //Close the READ end of the pipe since the child's fd is write-only
            dup2(fd[WRITE], 1); //Redirect stdout to pipe
        }
        else
        {
            close(fd[WRITE]);    //Close the WRITE end of the pipe since the child's fd is read-only
            dup2(fd[READ], 0);   //Redirect stdin to pipe
        }

        setpgid(child_pid, child_pid); //Needed so negative PIDs can kill children of /bin/sh
        execl("/bin/sh", "/bin/sh", "-c", command.c_str(), NULL);
        exit(0);
    }
    else
    {
        if (type == "r")
        {
            close(fd[WRITE]); //Close the WRITE end of the pipe since parent's fd is read-only
        }
        else
        {
            close(fd[READ]); //Close the READ end of the pipe since parent's fd is write-only
        }
    }

    pid = child_pid;

    if (type == "r")
    {
        return fdopen(fd[READ], "r");
    }

    return fdopen(fd[WRITE], "w");
}

// Gillespie code for pclose with pid extract
int pcloseGillespie(FILE * fp, pid_t pid)
{
    int stat;

    fclose(fp);
    while (waitpid(pid, &stat, 0) == -1)
    {
        if (errno != EINTR)
        {
            stat = -1;
            break;
        }
    }

    return stat;
}

// Opening monitor for ending test if time runs out
pid_t popenMonitor(pid_t commandPID,int millisToWait)
{
    pid_t child_pid;
    monitorAbort = 0;

    if((child_pid = fork()) == -1)
    {
        perror("fork");
        exit(1);
    }

    /* child process */
    if (child_pid == 0)
    {   
        // Catching signal to enable abort ability
        signal(SIGINT,sigintMonitorHandler);
        signal(SIGQUIT,sigquitMonitorHandler);

        // Waiting for command to finish
        std::this_thread::sleep_for(std::chrono::milliseconds(millisToWait));

        // Ending command
        kill(-commandPID, SIGKILL);

        // If monitorAbort is on, declare monitor was aborted
        if(monitorAbort){
          exit(2);
        }

        // Exiting
        exit(0);
    }

    return child_pid;
}

// Gillespie code for pclose with pid extract
int pcloseMonitor(pid_t monitorPID)
{   
    // Initializing
    int monitorStatusBeforeKill = -1;
    int monitorStatusAfterKill = -1;
    int returnStatus;
    int waitReturnBeforeKill = -1;
    int waitReturnAfterKill = -1;

    // Checking if monitor has exited before trying to terminate it
    waitReturnBeforeKill = waitpid(monitorPID,&monitorStatusBeforeKill,WNOHANG);
    
    // Ending monitor
    kill(monitorPID, SIGKILL);

    // Checking if monitor has exited after trying to terminate it
    waitReturnAfterKill = waitpid(monitorPID,&monitorStatusAfterKill,0);

    // Checking if monitor exited normally or was forced exit
    if((waitReturnBeforeKill > 0 && WIFEXITED(monitorStatusBeforeKill) && WEXITSTATUS(monitorStatusBeforeKill) == 0) || 
       (waitReturnAfterKill > 0 && WIFEXITED(monitorStatusAfterKill) && WEXITSTATUS(monitorStatusAfterKill) == 0)){
      returnStatus =  1;
    }
    else if((waitReturnBeforeKill > 0 && WIFEXITED(monitorStatusBeforeKill) && WEXITSTATUS(monitorStatusBeforeKill) == 2) || 
           (waitReturnAfterKill > 0 && WIFEXITED(monitorStatusAfterKill) && WEXITSTATUS(monitorStatusAfterKill) == 2)){
      returnStatus =  0;
    }
    else{
      returnStatus =  -1;
    }

    return returnStatus;
}

// Signal handler for SIGINT
void sigintMonitorHandler(int num){
    // Declaring monitor should be aborted
    monitorAbort = 1;

    // Catching signal
    signal(SIGINT,sigintMonitorHandler);
}

// Signal handler for SIGQUIT
void sigquitMonitorHandler(int num){
    // Declaring monitor should be aborted
    monitorAbort = 1;
    
    // Catching signal
    signal(SIGQUIT,sigquitMonitorHandler);
}