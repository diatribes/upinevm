#include <unistd.h>
#include <string.h>

void main(void)
{
    const char stdout_string[] = "here is some standard output data";
    const char stderr_string[] = "here is some standard error data";
    write(STDOUT_FILENO, stdout_string, sizeof(stdout_string));
    write(STDERR_FILENO, stderr_string, sizeof(stderr_string));
    return;
}
