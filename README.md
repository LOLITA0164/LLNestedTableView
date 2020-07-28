1. 支持了 Cocoapods ，方便集成 : pod 'LLNestedTableView'
2. 新增了联动的标识，防止多个页面错误通知
3. 悬停位置的设置改用回调的方式实现
4. 如果你的内容视图非上述两个视图，如 UIScrollView，请自行转换成上述两个视图，或者根据 列表视图 或者 集合视图实现的方式自行实现，大体思路不变
5. 关于 内容视图 和 主列表 同时滚动的问题，目前解决方案是，手动禁止某些滚动视图的滚动事件。PS：另一种思路是改写关键方法 -gestureRecognizer: shouldRecognizeSimultaneouslyWithGestureRecognizer: 的值，笔者目前还没有踩坑，只提供一种思路
6. UITableView/UICollectionView 需要弹性效果，UITableView 竖直方向默认是开启的，UICollectionView 在数量少，内容视图小于可见视图时，弹性是关闭的，你需要设置 alwaysBounceVertical 为 YES/true


