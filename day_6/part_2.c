#include <stdio.h>
#include <string.h>

typedef unsigned long long ull;

void next_iter(ull* restrict current, ull* restrict next) {
	memset(next, 0, 9*sizeof(ull));
	for(int i = 0; i <= 6; i++) {
		next[((i - 1) + 7) % 7] = current[i];
	}
	next[8] = current[0];
	next[7] = current[8];
	next[6] += current[7];
}

int main() {
	ull init_state[9] = {0};
	ull other_state[9];
	ull age;
	while(scanf("%llu%*c", &age) == 1) {
		init_state[age]++;
	}

	ull* current = init_state;
	ull* next = other_state;

	for(int i = 0; i < 256; i++) {
		next_iter(current, next);

		ull* temp = current;
		current = next;
		next = temp;
	}
	
	ull sum = 0;
	for(int i = 0; i < 9; i++) {
		printf("%d: %llu\n", i, current[i]);
		sum += current[i];
	}
	puts("");
	printf("total: %llu\n", sum);
}
