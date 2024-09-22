fun miniMaxSum(arr: List<Int>) {
    var min = arr[0]
    var max = arr[0]
    var sum: Long = 0

    for (i in arr.indices) {
        sum += arr[i]
        if (arr[i] < min) {
            min = arr[i]
        }
        if (arr[i] > max) {
            max = arr[i]
        }
    }
    println("MiniMax Sum: ${sum - max} ${sum - min}")
}

fun findEvenOdd(arr: List<Int>) {
    val evenNumbers = arr.filter { it % 2 == 0 }
    val oddNumbers = arr.filter { it % 2 != 0 }

    println("Even Numbers: $evenNumbers")
    println("Odd Numbers: $oddNumbers")
}

fun main(args: List<int>) {
   miniMaxSum(args)
   findEvenOdd(args)
}
