
import '../index.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppArray().colors[1],
      appBar: AppBar(
        backgroundColor: AppArray().colors[1],
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppArray().colors[4],
            )),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15).r,
        child: SingleChildScrollView(
          child: Column(
            spacing: 10.h,
            children: [
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is GetProfileloaded) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          spacing: 10.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Account',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppArray().colors[5]),
                            ),
                            Text(
                              state.profileModel.data.name,
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppArray().colors[3]),
                            ),
                            Text(
                              state.profileModel.data.fullName ?? 'N/A',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w100,
                                  color: AppArray().colors[5]),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/profile');
                            },
                            icon: Icon(
                              Icons.edit_outlined,
                              color: AppArray().colors[4],
                            ))
                      ],
                    );
                  } else if (state is ProfileError) {
                    print(state.message);
                  }
                  return SizedBox.shrink();
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is GetProfileloaded) {
                    return Row(
                      children: [
                        Column(
                          spacing: 10.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppArray().colors[5]),
                            ),
                            Text(
                              state.profileModel.data.email,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w100,
                                  color: AppArray().colors[5]),
                            ),
                          ],
                        )
                      ],
                    );
                  } else if (state is ProfileError) {
                    print(state.message);
                  }
                  return SizedBox.shrink();
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is GetProfileloaded) {
                    return Row(
                      children: [
                        Column(
                          spacing: 10.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mobile number',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppArray().colors[5]),
                            ),
                            Text(
                              state.profileModel.data.phoneNumber.toString() ??
                                  'N/A',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w100,
                                  color: AppArray().colors[5]),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notification',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppArray().colors[5]),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.arrow_forward_ios))
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Switch account',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppArray().colors[5]),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.arrow_forward_ios))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 10.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppArray().colors[5]),
                      ),
                      Text(
                        'Version',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppArray().colors[3]),
                      ),
                      Text(
                        '1.0.02',
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w100,
                            color: AppArray().colors[5]),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    spacing: 10.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terms & conditions',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppArray().colors[5]),
                      ),
                      Text(
                        'Privacy policy',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppArray().colors[3]),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<AuthBloc>().add(LogoutEvent());
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/landing', (route) => false);
                        },
                        child: Text(
                          'Log out all account',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w100,
                              color: Colors.red),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Delete account',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w100,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
