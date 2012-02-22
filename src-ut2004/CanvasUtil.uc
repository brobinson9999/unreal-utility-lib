class CanvasUtil extends Object
  dependsOn(Actor);

simulated static function drawCenteredSpriteAtWorldPosition(Canvas canvas, vector worldPosition, Texture crosshairTexture, optional Color drawColor) {
  local Actor.ERenderStyle e;
  local vector screenPosition;
  
  screenPosition = canvas.worldToScreen(worldPosition);
  
  canvas.drawColor = drawColor;
  canvas.drawColor.A = 255;
  e = STY_Alpha;
  canvas.style = e;

  canvas.setPos(screenPosition.x-(crosshairTexture.USize/4), screenPosition.y-(crosshairTexture.VSize/4));
  canvas.drawTile(crosshairTexture, crosshairTexture.USize/2, crosshairTexture.VSize/2, 0.0, 0.0, crosshairTexture.USize/2, crosshairTexture.VSize/2);
}

defaultproperties
{
}