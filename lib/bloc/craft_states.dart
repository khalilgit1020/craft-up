

abstract class CraftStates {}

class CraftInitialState extends CraftStates{}

class CraftThemeModeState extends CraftStates{}

class CraftLoginLoadingState extends CraftStates{}

class CraftLoginSuccessState extends CraftStates{
  final String uid;

  CraftLoginSuccessState(this.uid);
}

class CraftLoginErrorState extends CraftStates{
  final String error;
  CraftLoginErrorState(this.error);
}

class CraftChangePasswordVisibilityState extends CraftStates{}


class ChangeIsEmptyBoolState extends CraftStates {}



class CraftRegisterInitialState extends CraftStates {}

class CraftRegisterLoadingState extends CraftStates {}

class CraftRegisterSuccessState extends CraftStates
{

  final String uid;

  CraftRegisterSuccessState(this.uid);


}

class CraftRegisterErrorState extends CraftStates
{
  final String error;

  CraftRegisterErrorState(this.error);
}

class ShopRegisterChangePasswordVisibilityState extends CraftStates {}





class CraftChangeIsCrafterState extends CraftStates
{}



class CraftGetUserLoadingState extends CraftStates
{}

class CraftGetUserSuccessState extends CraftStates
{}

class CraftGetUserErrorState extends CraftStates
{
  final String error;

  CraftGetUserErrorState(this.error);
}


class CraftWriteSuggestionLoadingState extends CraftStates
{}

class CraftWriteSuggestionSuccessState extends CraftStates
{}

class CraftWriteSuggestionErrorState extends CraftStates
{
  final String error;

  CraftWriteSuggestionErrorState(this.error);
}



class CraftWriteCommentSuccessState extends CraftStates
{}

class CraftWriteCommentErrorState extends CraftStates
{
  final String error;

  CraftWriteCommentErrorState(this.error);
}





class CraftGetAllUsersLoadingState extends CraftStates
{}

class CraftGetAllUsersSuccessState extends CraftStates
{}

class CraftGetAllUsersErrorState extends CraftStates
{
  final String error;

  CraftGetAllUsersErrorState(this.error);
}

class CraftGetAllUsersMessengerLoadingState extends CraftStates
{}

class CraftGetAllUsersMessengerSuccessState extends CraftStates
{}

class CraftGetAllUsersMessengerErrorState extends CraftStates
{
  final String error;

  CraftGetAllUsersMessengerErrorState(this.error);
}







class CraftGetPostLoadingState extends CraftStates
{}

class CraftGetPostSuccessState extends CraftStates
{}

class CraftGetPostErrorState extends CraftStates
{
  final String error;

  CraftGetPostErrorState(this.error);
}


//CraftSearchSuccessStates   CraftSearchErrorStates  NewsSearchLoadingStates


class NewsSearchLoadingStates extends CraftStates
{}

class CraftSearchSuccessStates extends CraftStates
{}

class CraftSearchErrorStates extends CraftStates
{
  final String error;

  CraftSearchErrorStates(this.error);
}




class CraftGetPostCommentsLoadingState extends CraftStates
{}

class CraftGetPostCommentsSuccessState extends CraftStates
{}

class CraftGetPostCommentsErrorState extends CraftStates
{
  final String error;

  CraftGetPostCommentsErrorState(this.error);
}





class CraftGetPostCommentsUserSuccessState extends CraftStates
{}

class CraftGetPostCommentsUserErrorState extends CraftStates
{
  final String error;

  CraftGetPostCommentsUserErrorState(this.error);
}



// CraftGetPostCommentsNotificationUserSuccessState   CraftGetPostCommentsNotificationUserLoadingState




class CraftGetPostCommentsNotificationUserLoadingState extends CraftStates
{}

class CraftGetUserCommentState extends CraftStates{}



class CraftGetPostCommentsNotificationUserSuccessState extends CraftStates
{}

class CraftGetPostCommentsNotificationUserErrorState extends CraftStates
{
  final String error;

  CraftGetPostCommentsNotificationUserErrorState(this.error);
}






class CraftCreateUserSuccessState extends CraftStates
{}

class CraftCreateUserErrorState extends CraftStates
{
  final String error;

  CraftCreateUserErrorState(this.error);
}


class CraftChangeBottomNavState extends CraftStates{}




class CraftNewPostState extends CraftStates{}




class CraftProfileImagePickedSuccessState extends CraftStates{}

class CraftProfileImagePickedErrorState extends CraftStates{}




class CraftWorkImagePickedSuccessState extends CraftStates{}

class CraftWorkImagePickedErrorState extends CraftStates{}





class CraftUploadProfileImageSuccessState extends CraftStates{}

class CraftUploadProfileImageErrorState extends CraftStates{}



class CraftUploadWorkImageLoadingState extends CraftStates{}

class CraftUploadWorkImageSuccessState extends CraftStates{}

class CraftUploadWorkImageErrorState extends CraftStates{}






class CraftGetOtherWorkImageLoadingState extends CraftStates{}

class CraftGetOtherWorkImageSuccessState extends CraftStates{}

class CraftGetOtherWorkImageErrorState extends CraftStates{}





class CraftGetMyWorkImageLoadingState extends CraftStates{}

class CraftGetMyWorkImageSuccessState extends CraftStates{}

class CraftGetMyWorkImageErrorState extends CraftStates{}


// CraftEnableMessageButtonState


class CraftEnableMessageButtonState extends CraftStates{}

class CraftUnableMessageButtonState extends CraftStates{}





class CraftChangeCommentStateState extends CraftStates{}




class CraftMakeIsCrafterFalseState extends CraftStates{}

class CraftMakeIsCrafterTrueState extends CraftStates{}







class CraftLogoutLoadingState extends CraftStates{}

class CraftLogoutSuccessState extends CraftStates{}

class CraftLogoutErrorState extends CraftStates{}





class CraftGetSavedPostsLoadingState extends CraftStates{}

class CraftGetSavedPostsSuccessState extends CraftStates{}

class CraftGetSavedPostsErrorState extends CraftStates{}





class CraftSavePostSuccessState extends CraftStates{}

class CraftSavePostErrorState extends CraftStates{}




class CraftDeleteSavePostSuccessState extends CraftStates{}

class CraftDeleteSavePostErrorState extends CraftStates{}






class CraftDeleteWorkImageSuccessState extends CraftStates{}

class CraftDeleteWorkImageErrorState extends CraftStates{}



class CraftUserUpdateLoadingState extends CraftStates{}

class CraftUserUpdateSuccessState extends CraftStates{}

class CraftUserUpdateErrorState extends CraftStates{}



class CraftCreatePostLoadingState extends CraftStates{}

class CraftCreatePostSuccessState extends CraftStates{}

class CraftCreatePostErrorState extends CraftStates{}



class CraftPostImagePickedSuccessState extends CraftStates{}

class CraftPostImagePickedErrorState extends CraftStates{}




class CraftUploadMessageImageLoadingState extends CraftStates{}

class CraftUploadMessageImageSuccessState extends CraftStates{}

class CraftUploadMessageImageErrorState extends CraftStates{}




class CraftMessageImagePickedSuccessState extends CraftStates{}

class CraftMessageImagePickedErrorState extends CraftStates{}



class CraftRemovePostImageState extends CraftStates{}

class CraftSendMessageSuccessState extends CraftStates{}

class CraftSendMessageErrorState extends CraftStates{}



class CraftGetMessageLoadingState extends CraftStates{}

class CraftGetMessageSuccessState extends CraftStates{}

class CraftGetMessageErrorState extends CraftStates{}




class CraftResetPasswordLoadingState extends CraftStates{}

class CraftResetPasswordSuccessState extends CraftStates{}

class CraftResetPasswordErrorState extends CraftStates{

  final String error;
  CraftResetPasswordErrorState(this.error);

}






class ConvertUserTypeSuccessState extends CraftStates{}


class CraftEnableCommentButtonState extends CraftStates{}
class CraftUnableCommentButtonState extends CraftStates{}

