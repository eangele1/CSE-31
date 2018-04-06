#include <stdio.h>
#define MAXSIZE 4096

/**
 * You can use this recommended helper function
 * Returns true if partial_line matches pattern, starting from
 * the first char of partial_line.
 */

int matches_leading(char *partial_line, char *pattern) {
	return 0;
}

/**
 * You may assume that all strings are properly null terminated
 * and will not overrun the buffer set by MAXSIZE
 *
 * Implementation of the rgrep matcher function
 */

int string_length(char *p){
	int count = 0;
	while (*p != '\0') {
		count++;
		p++;
	}
	return count;
}

int rgrep_matches(char *line, char *pattern) {

	if (*pattern == '\0') {
		return 1;
	}

    //String length of pattern and line
	int pattern_length = string_length(pattern);
	int line_length = string_length(line);

    //Initializes variables
	int additional_iterations = 0;
	
	int firstpath = 0;
	int secondpath = 0;

	int point = 0;
	int line_position = 0;

    //Main loop
	start:
	for (line_position = 0; line_position < line_length; line_position++) {
        //If the line is a null terminator, return 0
		if (line[line_position] == '\0') {
			return 0;
		}

		if (pattern[point] == '\\') {
			if(pattern[point + 2] == '?') {
				point++;
				goto questions_case;
			}
			if (pattern[point + 1] == line[line_position]) {
				point++;
			}
			else {
				point = 0;
				continue;
			}
		}

        //For '?' cases
		questions_case:
		if(pattern[point + 1] == '?'){

			if(pattern[point] == '.'){

				if (additional_iterations == 0) {
					additional_iterations++;
				}
				else {
					additional_iterations = 0;
				}

				if(firstpath){
					goto second;
				}
				if (secondpath){
					goto first;
				}

			}
			if (line[line_position] == pattern[point]){
				first:
				firstpath = 1;

				point = point + 2;

				//for single letter cases
				if (line_position + 2 >= line_length){
					point++;
				}
				//sort of "hacky" code
				if (point >= pattern_length)
					goto end;
				
				continue;
			}
			else {
				second:
				secondpath = 1;

				point = point + 2;

				//again, sort of "hacky" code
				if (point >= pattern_length)
					goto end;

				line_position = line_position - 1;
				continue;
			}
		}

        //For '+' cases
		if (pattern[point + 1] == '+') {
            //'.' implementation
			char recurr = 0;
			int i = 0;
			int plus_offset = 0;

			if (pattern[point] == '.'){
				recurr = line[line_position];
			}

			if (pattern[point + 2] == pattern[point]){
				plus_offset++;
			}
			while (1) {
				if (line[line_position + i] == pattern[point] || line[line_position + i] == recurr) {
					i++;
				}
				else if (i != 0){

					/*if the (i > 1) comparison was not here,
					the plus_offset would cause us to incorrectly
					return words like "aba" with the "a+ab" queries
					*/
					if (i > 1) {
						line_position = line_position + i - 1 - plus_offset;
					}
					else{
						line_position = line_position + i - 1;
					}
					point = point + 2;
					break;
				}
				else{
					break;
				}
			}
			goto end;
		}

		//If they're equal to each other or '.'
		if (line[line_position] == pattern[point] || pattern[point] == '.') {
			point++;
		}
		else {
			point = 0;
			continue;
		}

		end:
    	//The only way to return 1, is to make the point = pattern length
		if (point >= pattern_length) {
			return 1;
		}
	}
    //Recurses whole loop if necessary.
	if (additional_iterations > 0){
		goto start;
	}

	return 0;
}

int main(int argc, char **argv) {
	if (argc != 2) {
		fprintf(stderr, "Usage: %s <PATTERN>\n", argv[0]);
		return 2;
	}

    /* we're not going to worry about long lines */
	char buf[MAXSIZE];

	while (!feof(stdin) && !ferror(stdin)) {
		if (!fgets(buf, sizeof(buf), stdin)) {
			break;
		}
		if (rgrep_matches(buf, argv[1])) {
			fputs(buf, stdout);
			fflush(stdout);
		}
	}

	if (ferror(stdin)) {
		perror(argv[0]);
		return 1;
	}

	return 0;
}
