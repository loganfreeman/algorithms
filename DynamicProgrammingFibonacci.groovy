class DynamicProgrammingFibonacci implements Fibonacci {

    private List<Integer> cache = []

    @Override
    int fib(final int i) {
        cache[0] = 0
        cache[1] = 1
        for (int j = 2; j <= i; j++) {
            cache[j] = cache[j - 1] + cache[j - 2]
        }
        return cache[i]
    }
}
