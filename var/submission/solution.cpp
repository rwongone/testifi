#include <iostream>
#include <vector>

using namespace std;

void print(vector<int> A) {
	for (vector<int>::iterator it=A.begin(); it!=A.end(); ++it) {
		cout << *it << " ";
	}
	cout << endl;
}

// Count the inversions which have one element in L and one element in R,
// and also perform a merge of the two subarrays as in mergesort, where
// A is the result.
//
// Assumptions:
// L and R are sorted ascending.
// L is the left subarray,
// R is the right subarray.
long long merge_and_count(vector<int> &A, vector<int> L, vector<int> R) {
	long long result = 0;
	vector<int>::iterator it = L.begin();
	vector<int>::iterator it2 = R.begin();
	int i = 0;
	int j = 0;

	while (it != L.end() && it2 != R.end()) {
		i = L.size() - (L.end() - it);
		j = R.size() - (R.end() - it2);
		if (*it > *it2) {
			result += L.end() - it;
			A[i+j] = *it2;
			++it2;
		} else {
			A[i+j] = *it;
			++it;
		}
	}

	while (it != L.end()) {
		i = L.size() - (L.end() - it);
		j = R.size() - (R.end() - it2);
		A[i+j] = *it;
		++it;
	}

	while (it2 != R.end()) {
		i = L.size() - (L.end() - it);
		j = R.size() - (R.end() - it2);
		A[i+j] = *it2;
		++it2;
	}

	return result;
}

// Perform a recursive count of inversions in A.
// Partition A into a left and right subarray.
// Count the inversions in L only and in R only, and sort them.
// Count the inversions where one element is in L and the other is in R,
// and merge the subarrays.
// Return the final count.
long long count_and_sort(vector<int> &A) {
	if (A.size() <= 1) {
		return 0LL;
	} // else size > 1

	vector<int>::iterator start = A.begin();
	vector<int>::iterator mid = A.begin() + A.size()/2;
	vector<int>::iterator end = A.end();

	vector<int> L(start, mid);
	vector<int> R(mid, end);

	long long left_result = count_and_sort(L);
	long long right_result = count_and_sort(R);
	long long cross_result = merge_and_count(A, L, R);

	return left_result + right_result + cross_result;
}

int main(int argc, char* argv[]) {
	vector<int> A;

	int token;
	while (cin >> token) {
		A.push_back(token);
	}

	cout << count_and_sort(A) << endl;
}
