class BaseObjectPool extends MyObjectPool;

// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

  simulated function object getInstance() {
    local BaseObject result;
    
    result = BaseObject(super.getInstance());
    result.reset();
    
    return result;
  }
  
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************
// ********************************************************************************************************************************************

defaultproperties
{
}