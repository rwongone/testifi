import java.util.Scanner;
public class SurfsUp {
	public static void main(String[] args) {
		Scanner input = new Scanner(System.in);
		int waveHeight = input.nextInt();
		if (waveHeight>=6)
			System.out.println("Go surfing");
		else
			System.out.println("No surfing");
	}
}
