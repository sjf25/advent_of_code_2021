#include <stdio.h>
#include <string.h>

void next_iter(int* restrict current, int* restrict next) {
	memset(next, 0, 9*sizeof(int));
	for(int i = 0; i <= 6; i++) {
		next[((i - 1) + 7) % 7] = current[i];
	}
	next[8] = current[0];
	next[7] = current[8];
	next[6] += current[7];
}

int main() {
	int init_state[9] = {0};
	int other_state[9];
	int age;
	while(scanf("%d%*c", &age) == 1) {
		init_state[age]++;
	}

	int* current = init_state;
	int* next = other_state;

	for(int i = 0; i < 80; i++) {
		next_iter(current, next);

		int* temp = current;
		current = next;
		next = temp;
	}
	
	int sum = 0;
	for(int i = 0; i < 9; i++) {
		printf("%d: %d\n", i, current[i]);
		sum += current[i];
	}
	puts("");
	printf("total: %d\n", sum);
}
