#include<stdio.h>
#include<stdlib.h>
int main(int argc, char *argv[]){
	FILE *sourcefile;
	FILE *destinationfile;
	// argc=3 (source, destination and argv[0] will be executable
	if(argc!=3){
		printf("source and destination file, both not mentioned");
		exit(1);
	}

	//open source file
	sourcefile=fopen(argv[1], "r");
	if(sourcefile==NULL){
		printf("Error in opening the file\n");
		exit(1);
	}
	
	//open destination file
	destinationfile=fopen(argv[2],"w");
	if(destinationfile==NULL){
		printf("Error opening the destination file\n");
		fclose(sourcefile);
		exit(1);
	}

	//copying contents from source to destination
	int ch;
	while((ch=fgetc(sourcefile)) !=EOF){
		fputc(ch, destinationfile);
	}
	printf("File copying completed successfully\n");
	fclose(sourcefile);
	fclose(destinationfile);
	return 0;


}


