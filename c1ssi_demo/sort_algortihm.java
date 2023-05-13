//排序算法的本质就是要尽量少交换次数
//C++标准库包括6大组件13个头文件 容器、迭代器、算法、适配器
//JAVA主要是string/list/set/map家族
// Java 代码实现
public class BubbleSort implements IArraySort {

@Override
public int[] sort(int[] sourceArray) throws Exception {
// 对 arr 进行拷贝，不改变参数内容
int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);

for (int i = 1; i < arr.length; i++) {
    // 设定一个标记，若为true，则表示此次循环没有进行交换，也就是待排序列已经有序，排序已经完成。
    boolean flag = true;

    for (int j = 0; j < arr.length - i; j++) {
        if (arr[j] > arr[j + 1]) {
            int tmp = arr[j];
            arr[j] = arr[j + 1];
            arr[j + 1] = tmp;

            flag = false;
        }
    }

    if (flag) {
        break;
    }
}   
return arr;
}
}
//快速排序
public class QuickSort implements IArraySort {

    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝，不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);

       return quickSort(arr, 0, arr.length - 1);
    }

    private int[] quickSort(int[] arr, int left, int right) {
        if (left < right) {
            int partitionIndex = partition(arr, left, right);
            quickSort(arr, left, partitionIndex - 1);
           quickSort(arr, partitionIndex + 1, right);
        }
        return arr;
    }

    private int partition(int[] arr, int left, int right) {
        // 设定基准值（pivot）
        int pivot = left;
        int index = pivot + 1;
        for (int i = index; i <= right; i++) {
            if (arr[i] < arr[pivot]) {
                swap(arr, i, index);
                index++;
            }
        }
        swap(arr, pivot, index - 1);
        return index - 1;
    }

    private void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
       arr[j] = temp;
    }

 }
//归并排序
 //Java 代码实现
public class MergeSort implements IArraySort {

    @Override
    public int[] sort(int[] sourceArray) throws Exception {
    // 对 arr 进行拷贝，不改变参数内容
    int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);

    if (arr.length < 2) {
        return arr;
    }
    int middle = (int) Math.floor(arr.length / 2);

    int[] left = Arrays.copyOfRange(arr, 0, middle);
    int[] right = Arrays.copyOfRange(arr, middle, arr.length);

    return merge(sort(left), sort(right));
    }

    protected int[] merge(int[] left, int[] right) {
    int[] result = new int[left.length + right.length];
    int i = 0;
    while (left.length > 0 && right.length > 0) {
        if (left[0] <= right[0]) {
            result[i++] = left[0];
            left = Arrays.copyOfRange(left, 1, left.length);
        } else {
            result[i++] = right[0];
            right = Arrays.copyOfRange(right, 1, right.length);
        }
    }

    while (left.length > 0) {
        result[i++] = left[0];
        left = Arrays.copyOfRange(left, 1, left.length);
    }

    while (right.length > 0) {
        result[i++] = right[0];
        right = Arrays.copyOfRange(right, 1, right.length);
    }

    return result;
    }

}