import 'package:injectable/injectable.dart';
import 'package:swe/_application/core/base_cubit.dart';
import 'package:swe/_application/profile/profile_state.dart';
import 'package:swe/_domain/profile/i_profile_repository.dart';

@injectable
final class ProfileCubit extends BaseCubit<ProfileState> {
  final IProfileRepository _profileRepository;
  ProfileCubit(this._profileRepository) : super(ProfileState.initial());

  void init() {}

  @override
  void setLoading(bool loading) {
    safeEmit(state.copyWith(isLoading: loading));
  }
}
