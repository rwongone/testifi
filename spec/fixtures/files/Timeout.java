import java.util.*;

public class Timeout {
    static int sum(ArrayList<Integer> a) {
        int toReturn = 0;
        while (true) {
            if (toReturn - 1 == 1) break;
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
