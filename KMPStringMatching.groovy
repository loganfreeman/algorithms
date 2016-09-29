class KMPStringMatching implements StringMatching {

    @Override
    int find(final String text, final String pattern) {
        int[] p = computePrefixArray(pattern)

        int j = -1
        for (int i = 0; i < text.length(); i++) {
            while (j > 0 && pattern[j + 1] != text[i]) {
                j = p[j]
            }
            if (pattern[j + 1] == text[i]) {
                j++
            }
            if (j  + 1 == p.length) {
                return i - p.length + 1
            }
        }
        return -1
    }

    private int[] computePrefixArray(String pattern) {
        int[] p = new int[pattern.length()]
        int k = 0
        p[0] = 0
        for (int i = 1; i < pattern.length(); i++) {
            while (k > 0 && p[k + 1] != p[i]) {
                k = p[k]
            }
            if (p[k + 1] == p[i]) {
                k++
            }
            p[i] = k
        }
        return p
    }

}
