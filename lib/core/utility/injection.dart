import 'package:appkey_taxiapp_driver/core/data/datasources/customer_detail_datasource.dart';
import 'package:appkey_taxiapp_driver/core/data/datasources/price_category_datasource.dart';
import 'package:appkey_taxiapp_driver/core/data/datasources/update_location_datasource.dart';
import 'package:appkey_taxiapp_driver/core/data/repositories/currency_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/core/data/repositories/customer_detail_repository_impl.dart';
import 'package:appkey_taxiapp_driver/core/data/repositories/price_cateogory_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/core/data/repositories/total_price_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/core/data/repositories/update_location_repo_impl.dart';
import 'package:appkey_taxiapp_driver/core/domain/repositories/currency_repository.dart';
import 'package:appkey_taxiapp_driver/core/domain/repositories/customer_detail_repository.dart';
import 'package:appkey_taxiapp_driver/core/domain/repositories/price_category_repository.dart';
import 'package:appkey_taxiapp_driver/core/domain/repositories/total_price_repository.dart';
import 'package:appkey_taxiapp_driver/core/domain/usecases/do_update_location.dart';
import 'package:appkey_taxiapp_driver/core/domain/usecases/get_currency.dart';
import 'package:appkey_taxiapp_driver/core/domain/usecases/get_customer_detail.dart';
import 'package:appkey_taxiapp_driver/core/domain/usecases/get_total_price.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/place_picker_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/splash_provider.dart';
import 'package:appkey_taxiapp_driver/features/about_us/data/datasources/aboutus_data_source.dart';
import 'package:appkey_taxiapp_driver/features/about_us/data/repositories/aboutus_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/features/about_us/domain/usecases/get_aboutus.dart';
import 'package:appkey_taxiapp_driver/features/about_us/presentation/providers/aboutus_provider.dart';
import 'package:appkey_taxiapp_driver/features/chat/presendtation/provider/chat_provider.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/data/datasource/contact_us_data_source.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/data/repositories/contact_us_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/domain/repositories/contact_us_repository.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/domain/usercases/do_contact_us.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/persentation/provider/contact_us_provider.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/datasource/create_profile_data_source.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/repositories/create_profile_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/domain/repositories/create_profile_repository.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/domain/usecases/do_create_profile.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_provider.dart';
import 'package:appkey_taxiapp_driver/features/forgot_password/data/repositories/forgot_password_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/features/forgot_password/domain/usecases/do_forgot_password.dart';
import 'package:appkey_taxiapp_driver/features/forgot_password/presentation/providers/forgot_password_provider.dart';
import 'package:appkey_taxiapp_driver/features/history/data/repositories/profile_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/features/history/domain/repositories/profile_repository.dart';
import 'package:appkey_taxiapp_driver/features/history/domain/usecases/get_history.dart';
import 'package:appkey_taxiapp_driver/features/history/presentation/providers/history_provider.dart';
import 'package:appkey_taxiapp_driver/features/login/data/datasources/login_data_source.dart';
import 'package:appkey_taxiapp_driver/features/login/data/repositories/login_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/features/login/domain/usecases/do_login.dart';
import 'package:appkey_taxiapp_driver/features/order/data/datasources/order_data_source.dart';
import 'package:appkey_taxiapp_driver/features/order/data/repositories/order_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/usecases/get_driver_detail.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/usecases/get_driver_location.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/usecases/get_order_detail.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/usecases/get_request_list.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/usecases/get_status_order.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/usecases/update_status_order.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/data/datasources/profile_data_source.dart';
import 'package:appkey_taxiapp_driver/features/profile/data/repositories/profile_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/features/profile/domain/usecases/get_profile.dart';
import 'package:appkey_taxiapp_driver/features/profile/domain/usecases/update_email.dart';
import 'package:appkey_taxiapp_driver/features/profile/domain/usecases/update_password.dart';
import 'package:appkey_taxiapp_driver/features/profile/domain/usecases/update_profile.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/change_email_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/change_password_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_edit_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_provider.dart';
import 'package:appkey_taxiapp_driver/features/rating/data/datasource/rating_data_source.dart';
import 'package:appkey_taxiapp_driver/features/rating/data/repositories/rating_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/features/rating/domain/repositories/rating_repository.dart';
import 'package:appkey_taxiapp_driver/features/rating/domain/usercases/do_rating.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/providers/rating_provider.dart';
import 'package:appkey_taxiapp_driver/features/receipt/data/datasource/receipt_data_source.dart';
import 'package:appkey_taxiapp_driver/features/receipt/data/repositories/receipt_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:appkey_taxiapp_driver/features/receipt/domain/usercases/do_contact_us.dart';
import 'package:appkey_taxiapp_driver/features/receipt/persentation/provider/receipt_provider.dart';
import 'package:appkey_taxiapp_driver/features/signup/data/datasource/signup_data_source.dart';
import 'package:appkey_taxiapp_driver/features/signup/data/repositories/signup_repository_implementation.dart';
import 'package:appkey_taxiapp_driver/features/signup/domain/repositories/signup_repository.dart';
import 'package:appkey_taxiapp_driver/features/signup/domain/usecases/do_signup.dart';
import 'package:appkey_taxiapp_driver/features/signup/presentation/provider/signup_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/about_us/domain/repositories/aboutus_repository.dart';
import '../../features/forgot_password/data/datasources/forgot_password_data_source.dart';
import '../../features/forgot_password/domain/repositories/forgot_password_repository.dart';
import '../../features/history/data/datasources/history_data_source.dart';
import '../../features/login/domain/repositories/login_repository.dart';
import '../../features/login/presentation/providers/login_provider.dart';
import '../../features/order/domain/repositories/order_repository.dart';
import '../../features/order/domain/usecases/change_status.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../data/datasources/currency_datasource.dart';
import '../data/datasources/place_text_search_datasource.dart';
import '../data/datasources/total_price_datasource.dart';
import '../data/repositories/google_place_repository_implementation.dart';
import '../domain/repositories/google_place_repository.dart';
import '../domain/repositories/update_location_repository.dart';
import '../domain/usecases/get_google_place.dart';
import '../domain/usecases/get_price_category.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../presentation/providers/fcm_provider.dart';
import 'session_helper.dart';

late Locale myLocale;

late Session sessionHelper;
late bool isLoggedIn;

final locator = GetIt.instance;

Future<void> init() async {
  //network info
  locator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImplementation(locator<Connectivity>()));

  //external
  locator.registerLazySingleton<Dio>(() => DioClient().dio);
  locator.registerLazySingletonAsync<Session>(() async =>
      SessionHelper(pref: await locator.getAsync<SharedPreferences>()));
  locator.registerLazySingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());
  locator.registerLazySingleton<GlobalKey<NavigatorState>>(
      () => GlobalKey<NavigatorState>());
  locator.registerLazySingleton<Connectivity>(() => Connectivity());
  locator.registerLazySingleton<GlobalKey<ScaffoldState>>(
      () => GlobalKey<ScaffoldState>());

  //repository
  locator.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImplementation(
      dataSource: locator<CurrencyDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );
  locator.registerLazySingleton<CustomerDetailRepository>(
    () => CustomerDetailRepositoryImplementation(
      dataSource: locator<CustomerDetailDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );
  locator.registerLazySingleton<PriceCategoryRepository>(
    () => PriceCategoryRepositoryImplementation(
      dataSource: locator<PriceCategoryDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );
  locator.registerLazySingleton<TotalPriceRepository>(
    () => TotalPriceRepositoryImplementation(
      dataSource: locator<TotalPriceDataSource>(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );
  locator.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImplementation(
      dataSource: locator<LoginDataSource>(),
    ),
  );
  locator.registerLazySingleton<ReceiptRepository>(
    () => ReceiptRepositoryImplementation(
      dataSource: locator<ReceiptDataSource>(),
    ),
  );

  locator.registerLazySingleton<SignupRepository>(
      () => SignupRepositoryImplementation(
            dataSource: locator<SignupDataSource>(),
          ));

  locator.registerLazySingleton<CreateProfileRepository>(() =>
      CreateProfileRepositoryImplementation(
          dataSource: locator<CreateProfileDataSource>()));

  locator.registerLazySingleton<ContactUsRepository>(() =>
      ContactUsRepositoryImplementation(
          dataSource: locator<ContactUsDataSource>()));

  locator.registerLazySingleton<AboutUsRepository>(
    () => AboutUsRepositoryImplementation(
      dataSource: locator<AboutUsDataSource>(),
    ),
  );
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImplementation(
      dataSource: locator<ProfileDataSource>(),
    ),
  );
  locator.registerLazySingleton<RatingRepository>(
    () => RatingRepositoryImplementation(
      dataSource: locator<RatingDataSource>(),
    ),
  );
  locator.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImplementation(
      dataSource: locator<HistoryDataSource>(),
    ),
  );
  locator.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepositoryImplementation(
      dataSource: locator<ForgotPasswordDataSource>(),
    ),
  );
  locator.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImplementation(
      dataSource: locator<OrderDataSource>(),
    ),
  );
  locator.registerLazySingleton<UpdateLocationRepository>(
    () => UpdateLocationRepositoryImplementation(
      dataSource: locator<UpdateLocationDataSource>(),
    ),
  );

  //datasource
  locator.registerLazySingleton<CurrencyDataSource>(
      () => CurrencyDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<CustomerDetailDataSource>(
      () => CustomerDetailDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<PriceCategoryDataSource>(
      () => PriceCategoryDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<GooglePlaceDataSource>(
      () => GooglePlaceDataSourceImpl(dio: locator<Dio>()));
  locator.registerLazySingleton<GooglePlaceRepository>(() =>
      GooglePlaceRepositoryImpl(dataSource: locator(), networkInfo: locator()));
  locator.registerLazySingleton<TotalPriceDataSource>(
      () => TotalPriceDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<LoginDataSource>(
      () => LoginDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<SignupDataSource>(
      () => SignupDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<CreateProfileDataSource>(
      () => CreateProfileDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<ContactUsDataSource>(
      () => ContactUsDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<AboutUsDataSource>(
      () => AboutUsDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<ProfileDataSource>(
      () => ProfileDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<HistoryDataSource>(
      () => HistoryDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<ForgotPasswordDataSource>(
      () => ForgotPasswordDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<OrderDataSource>(
      () => OrderDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<UpdateLocationDataSource>(
      () => UpdateLocationDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<RatingDataSource>(
      () => RatingDataSourceImplementation(dio: locator<Dio>()));
  locator.registerLazySingleton<ReceiptDataSource>(
      () => ReceiptDataSourceImplementation(dio: locator<Dio>()));

  //usecase
  locator.registerLazySingleton<GetCustomerDetail>(
      () => GetCustomerDetail(locator<CustomerDetailRepository>()));
  locator.registerLazySingleton<GetCurrency>(
      () => GetCurrency(locator<CurrencyRepository>()));
  locator.registerLazySingleton<GetPriceCategory>(
      () => GetPriceCategory(locator<PriceCategoryRepository>()));
  locator.registerLazySingleton<GetGooglePlace>(
      () => GetGooglePlace(repository: locator()));
  locator.registerLazySingleton<GetTotalPrice>(
      () => GetTotalPrice(locator<TotalPriceRepository>()));
  locator.registerLazySingleton<DoLogin>(
      () => DoLogin(repository: locator<LoginRepository>()));
  locator.registerLazySingleton<DoSignup>(
      () => DoSignup(repository: locator<SignupRepository>()));
  locator.registerLazySingleton<DoCreateProfile>(
      () => DoCreateProfile(repository: locator<CreateProfileRepository>()));
  locator.registerLazySingleton<DoContactUs>(
      () => DoContactUs(repository: locator<ContactUsRepository>()));
  locator.registerLazySingleton<GetAboutUs>(
      () => GetAboutUs(repository: locator<AboutUsRepository>()));
  locator.registerLazySingleton<GetProfile>(
      () => GetProfile(repository: locator<ProfileRepository>()));
  locator.registerLazySingleton<GetHistory>(
      () => GetHistory(repository: locator<HistoryRepository>()));
  locator.registerLazySingleton<UpdateProfile>(
      () => UpdateProfile(repository: locator<ProfileRepository>()));
  locator.registerLazySingleton<UpdateEmail>(
      () => UpdateEmail(repository: locator<ProfileRepository>()));
  locator.registerLazySingleton<UpdatePassword>(
      () => UpdatePassword(repository: locator<ProfileRepository>()));
  locator.registerLazySingleton<DoForgotPassword>(
      () => DoForgotPassword(repository: locator<ForgotPasswordRepository>()));
  locator.registerLazySingleton<ChangeStatus>(
      () => ChangeStatus(repository: locator<OrderRepository>()));
  locator.registerLazySingleton<UpdateStatusOrder>(
      () => UpdateStatusOrder(repository: locator<OrderRepository>()));
  locator.registerLazySingleton<GetStatusOrder>(
      () => GetStatusOrder(repository: locator<OrderRepository>()));
  locator.registerLazySingleton<GetOrderDetail>(
      () => GetOrderDetail(repository: locator<OrderRepository>()));
  locator.registerLazySingleton<GetRequestList>(
      () => GetRequestList(repository: locator<OrderRepository>()));
  locator.registerLazySingleton<GetDriverDetail>(
      () => GetDriverDetail(repository: locator<OrderRepository>()));
  locator.registerLazySingleton<GetDriverLocation>(
      () => GetDriverLocation(repository: locator<OrderRepository>()));
  locator.registerLazySingleton<DoUpdateLocation>(
      () => DoUpdateLocation(repository: locator<UpdateLocationRepository>()));
  locator.registerLazySingleton<DoRating>(
      () => DoRating(repository: locator<RatingRepository>()));
  locator.registerLazySingleton<DoReceipt>(
      () => DoReceipt(repository: locator<ReceiptRepository>()));

  //providers
  locator.registerLazySingleton<FcmProvider>(() => FcmProvider());
  locator.registerFactory(
    () => SplashProvider(getCurrency: locator<GetCurrency>()),
  );
  locator.registerFactory(
    () => HomeProvider(
      updateStatusOrder: locator<UpdateStatusOrder>(),
      doUpdateLocation: locator<DoUpdateLocation>(),
      getCustomerDetail: locator<GetCustomerDetail>(),
      getRequestList: locator<GetRequestList>(),
      getOrderDetail: locator<GetOrderDetail>(),
      changeStatus: locator<ChangeStatus>(),
      getProfile: locator<GetProfile>(),
    ),
  );
  locator.registerFactory(
    () => OrderProvider(
        updateStatusOrder: locator<UpdateStatusOrder>(),
        getDriverDetail: locator<GetDriverDetail>(),
        getDriverLocation: locator<GetDriverLocation>(),
        doUpdateLocation: locator<DoUpdateLocation>(),
        getOrderDetail: locator<GetOrderDetail>(),
        getStatusOrder: locator<GetStatusOrder>()),
  );
  locator.registerFactory<PlacePickerProvider>(
      () => PlacePickerProvider(getGooglePlace: locator<GetGooglePlace>()));
  locator
      .registerFactory<LoginProvider>(() => LoginProvider(doLogin: locator()));
  locator.registerFactory<SignupProvider>(
      () => SignupProvider(doSignup: locator()));
  locator.registerFactory<ContactUsProvider>(
      () => ContactUsProvider(doContactUs: locator()));
  locator.registerFactory<CreateProfileProvider>(
      () => CreateProfileProvider(doCreateProfile: locator()));
  locator.registerFactory<ForgotPasswordProvider>(
      () => ForgotPasswordProvider(doForgotPassword: locator()));
  locator.registerFactory<AboutUsProvider>(
      () => AboutUsProvider(getAboutUs: locator()));
  locator.registerFactory<ProfileProvider>(
      () => ProfileProvider(getProfile: locator()));
  locator.registerFactory<HistoryProvider>(
      () => HistoryProvider(getHistory: locator()));
  locator.registerFactory<ProfileEditProvider>(() => ProfileEditProvider(
      updateProfile: locator(), getPriceCategory: locator()));
  locator.registerFactory<ChangeEmailProvider>(
      () => ChangeEmailProvider(updateEmail: locator()));
  locator.registerFactory<ChangePasswordProvider>(
      () => ChangePasswordProvider(updatePassword: locator()));
  locator.registerFactory<RatingProvider>(
      () => RatingProvider(doRating: locator()));
  locator.registerFactory<ReceiptProvider>(
      () => ReceiptProvider(doReceipt: locator()));
  locator.registerFactory<SocketProvider>(() => SocketProvider());
  locator.registerFactory<ChatProvider>(() => ChatProvider());
}
