import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Time "mo:base/Time";

actor {
  type CareActivity = {
    id: Nat;
    petName: Text;
    activityType: Text; 
    date: Time.Time;
    notes: Text;
  };

  var careLog = Buffer.Buffer<CareActivity>(0);

  public func addCareActivity(petName: Text, activityType: Text, notes: Text) : async Nat {
    let id = careLog.size();
    let newActivity: CareActivity = {
      id;
      petName;
      activityType;
      date = Time.now();
      notes;
    };
    careLog.add(newActivity);
    id
  };

  public query func getPetActivities(petName: Text) : async [CareActivity] {
    let activities = Buffer.Buffer<CareActivity>(0);
    for (activity in careLog.vals()) {
      if (activity.petName == petName) {
        activities.add(activity);
      };
    };
    Buffer.toArray(activities)
  };

  public query func getActivitiesByType(activityType: Text) : async [CareActivity] {
    let activities = Buffer.Buffer<CareActivity>(0);
    for (activity in careLog.vals()) {
      if (activity.activityType == activityType) {
        activities.add(activity);
      };
    };
    Buffer.toArray(activities)
  };

  public func updateActivityNotes(id: Nat, newNotes: Text) : async Bool {
    if (id >= careLog.size()) return false;
    let activity = careLog.get(id);
    let updatedActivity: CareActivity = {
      id = activity.id;
      petName = activity.petName;
      activityType = activity.activityType;
      date = activity.date;
      notes = newNotes;
    };
    careLog.put(id, updatedActivity);
    true
  };
}