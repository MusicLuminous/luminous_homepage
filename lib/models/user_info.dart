class UserInfo {
  final String qqNumber;
  final String nickname;
  final String signature;
  final String bio;
  final String avatarUrl;

  const UserInfo({
    required this.qqNumber,
    required this.nickname,
    required this.signature,
    required this.bio,
    required this.avatarUrl,
  });

  factory UserInfo.defaultData() {
    return const UserInfo(
      qqNumber: '3199169587',
      nickname: '殷灵涵 Luminous',
      signature: '小小世界 开心至上',
      bio: '二次元浓度极高，热衷于捣鼓各种有趣的项目。ACG 是生活必需品，代码是快乐源泉',
      avatarUrl: '',
    );
  }

  String get avatarUrlWithFallback => 
      avatarUrl.isNotEmpty ? avatarUrl : 'http://q.qlogo.cn/headimg_dl?dst_uin=$qqNumber&spec=640&img_type=jpg';
}
