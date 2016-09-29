class BruteForceMaxSubArray implements MaxSubArray {

    @Override
    SubArraySum findMaxSubArray(final List<Integer> array) {
        SortedSet<SubArraySum> results = new TreeSet<SubArraySum>({ SubArraySum o1, SubArraySum o2 ->
            int value = intComparator.call(o1.sum, o2.sum)
            if (value == 0) {
                value = intComparator.call(o1.from, o2.from)
                if (value == 0) {
                    value = intComparator.call(o1.to, o2.to)
                }
            }
            return value
        } as Comparator
                )
        for (int i = 0; i < array.size(); i++) {
            for (int j = i + 1; j <= array.size(); j++) {
                results.add(new SubArraySum(sum: sum(array, i, j), from: i, to: j))
            }
        }
        return results.first()
    }

    int sum(List<Integer> array, int from, int to) {
        int sum = 0
        for (int i = from; i < to; i++) {
            sum += array[i]
        }
        return sum
    }

    Closure<Integer> intComparator = { i1, i2 ->
        (i1 > i2) ? -1 : ((i1 < i2) ? 1 : 0)
    }
}
