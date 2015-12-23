#include <stdio.h>
#define MAX 1000

int indexOf(char a[], int size, char value){
    int index = 0;
    while (index < size && a[index] != value ){
    	++index;
    } 
    return (index == size ? -1 : index );
}

int isValid(char *text){
 	int i=0;
 	int size = 0;
 	char stack[MAX];
 	char openers[] = {'(', '{', '['};
 	char closers[] = {')', '}', ']'};
 	while(text[i] != '\n'){
 		size++;
 		i++;
 	}
 	int stackSize=0;
 	for(i=0; i<size; i++){
 		if(text[i] == '(' ||  text[i] == '{' || text[i] == '['){
 			*(stack+stackSize+1) = text[i];
 			stackSize++;
 		}else if(text[i] == ')' ||  text[i] == '}' || text[i] == ']'){
 			if(!(stackSize > 0)){
 				return 0;
 			}
 			char lastUnclosedOpener = *(stack+stackSize);
 			if(indexOf(openers, 3, lastUnclosedOpener) != indexOf(closers, 3, text[i])){
 				return 0;
 			}
 			stackSize--;
 		}
 	}
 	if(stackSize != 0){
 		return 0;
 	}
 	return 1;
 }

 int main(){
 	char text[MAX];
 	fgets(text, MAX, stdin);
 	int correct = isValid(text);
 	printf("%d\n", correct);
 }



