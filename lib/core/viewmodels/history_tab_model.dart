import 'package:carpool/core/models/trip.dart';
import 'package:carpool/core/services/api.dart';
import 'package:carpool/core/services/authentication_service.dart';
import 'package:carpool/core/viewmodels/base_model.dart';
import 'package:carpool/locator.dart';

class HistoryTabModel extends BaseModel {
  Api _api = locator<Api>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  List<Trip> _trips = List<Trip>();

  List<Trip> get trips => _trips;

  Future<void> init() async {
    setBusy(true);
    print('@HistoryTabModel.init: init');
    _trips = await _api.getTripFor(_authenticationService.currentUser.id);
    setBusy(false);
  }

  String tripStateToReadable(TripState state) {
    switch (state) {
      case TripState.WaitingForApproval:
        return 'Waiting for Approval';
      case TripState.WaitingForApprovalBooked:
        return 'Waiting for Book Approval';
      case TripState.DeniedByUser:
        return 'Denied by You';
      case TripState.DeniedByAdmin:
        return 'Denied by Admin';
      case TripState.FindingDriver:
        return 'Finding Driver';
      case TripState.OnTheWay:
        return 'On the Way';
      case TripState.Finished:
        return 'Finished';
      default:
        return 'Loading';
    }
  }
}
