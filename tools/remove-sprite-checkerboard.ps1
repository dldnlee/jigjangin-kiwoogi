param([Parameter(Mandatory=$true)][string]$InputPng,[Parameter(Mandatory=$true)][string]$OutputPng)
# User-authorized cleanup of a generated checkerboard. Flood-fill only neutral,
# light pixels connected to the image boundary; dark outlines protect clothing.
Add-Type -AssemblyName System.Drawing
Add-Type -TypeDefinition @'
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
public static class SpriteAlphaCleanup {
  public static void Run(string source, string output) {
    using (var original = new Bitmap(source))
    using (var bitmap = original.Clone(new Rectangle(0, 0, original.Width, original.Height), PixelFormat.Format32bppArgb)) {
      int w = bitmap.Width, h = bitmap.Height;
      var bits = bitmap.LockBits(new Rectangle(0,0,w,h), ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
      int stride = bits.Stride;
      var data = new byte[stride*h]; Marshal.Copy(bits.Scan0,data,0,data.Length);
      var seen = new bool[w*h]; var queue = new int[w*h]; int head=0,tail=0;
      Action<int> enqueue = index => {
        if(index<0 || index>=w*h || seen[index]) return;
        seen[index]=true;
        int p=(index/w)*stride+(index%w)*4;
        int max=Math.Max(data[p],Math.Max(data[p+1],data[p+2]));
        int min=Math.Min(data[p],Math.Min(data[p+1],data[p+2]));
        if(min>=168 && max-min<=32) queue[tail++]=index;
      };
      for(int x=0;x<w;x++){enqueue(x);enqueue((h-1)*w+x);}
      for(int y=0;y<h;y++){enqueue(y*w);enqueue(y*w+w-1);}
      while(head<tail) {
        int i=queue[head++],x=i%w,y=i/w;
        data[y*stride+x*4+3]=0;
        if(x>0)enqueue(i-1);if(x<w-1)enqueue(i+1);
        if(y>0)enqueue(i-w);if(y<h-1)enqueue(i+w);
      }
      Marshal.Copy(data,0,bits.Scan0,data.Length); bitmap.UnlockBits(bits);
      bitmap.Save(output,ImageFormat.Png);
      Console.WriteLine("Made {0} background pixels transparent; {1}x{2} RGBA",tail,w,h);
    }
  }
}
'@ -ReferencedAssemblies System.Drawing
[SpriteAlphaCleanup]::Run((Resolve-Path -LiteralPath $InputPng).Path,[IO.Path]::GetFullPath($OutputPng))
