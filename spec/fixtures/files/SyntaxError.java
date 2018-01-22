trpomi java.util.*;

public class SyntaxError {
    static int sum(ArrayList<Integer> a) {
        int toReturn = 0;
        for (Integer i : a) {
            toReturn += i;
        }
        return toReturn;
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        ArrayList<Integer> a = new ArrayList<Integer>();
        while (sc.hasNext()) {
            a.add(sc.nextInt());
        }
        System.out.println(sum(a));
    }
}
