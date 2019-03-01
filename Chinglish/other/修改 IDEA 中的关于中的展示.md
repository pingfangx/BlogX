根据 JVM: {0} by {1} 找到名为

IdeBundle.properties
about.box.vm=JVM: {0} by {1}

定位到 com.intellij.ide.actions.AboutPopup.InfoSurface#InfoSurface

    
    myLines.add(new AboutBoxLine(IdeBundle.message("about.box.vm", vmVersion, vmVendor)));
    appendLast();
    
    appendLast() 用来将文字添加到 myInfo 中
    而 myInfo 只是用来复制时使用的
    
    然后每一行是单独渲染出来的
    
    
    com.intellij.ide.actions.AboutPopup.InfoSurface#paint
        renderer.render(0, 0, myLines);
        
    com.intellij.ide.actions.AboutPopup.InfoSurface.TextRenderer#render
        renderString(s, indentX);
        
    com.intellij.ide.actions.AboutPopup.InfoSurface.TextRenderer#renderString
      private void renderString(final String s, final int indentX) throws OverflowException {
        final List<String> words = StringUtil.split(s, " ");
        //遍历所有单词
        for (String word : words) {
          int wordWidth = fontmetrics.stringWidth(word);
          if (x + wordWidth >= w) {
            //如果宽度超了，则换行
            lineFeed(indentX, word);
          }
          //渲染文字
          renderWord(word, indentX);
        }
      }
    
      private void lineFeed(int indent, final String s) throws OverflowException {
        x = indent;
        if (s.length() == 0) {
          y += fontHeight / 3;
        }
        else {
          y += fontHeight;
        }
        if (y >= h) {
          throw new OverflowException();
        }
      }
    com.intellij.ide.actions.AboutPopup.InfoSurface.TextRenderer#renderWord
    
            final int cW = fontmetrics.charWidth(c);
            if (x + cW >= w) {
              lineFeed(indentX, s);
            }
    
# 总结
* 无法渲染 \n \t 等字符
* 按行渲染，每一行以空格区分单词
* 按单词渲染，如果长度不够渲染单词，则会换行
* 按每个字符渲染，如果长度不够渲染字符，则会换行

# 宽度
## 字体宽度
    com.intellij.ide.actions.AboutPopup.InfoSurface.TextRenderer#renderWord
            if (!g2.getFont().canDisplay(c)) {
              f = g2.getFont();
              fm = fontmetrics;
              g2.setFont(new Font("Monospaced", f.getStyle(), f.getSize()));
              fontmetrics = g2.getFontMetrics();
            }
            
不能显示中文字体，会重新设置字体。  
设置前，每个字符宽度为 9 ，设置后，每个字符宽度为 14。（可能与设置有关）
网址宽 167。
## 窗体宽度
    com.intellij.ide.actions.AboutPopup#show
        Icon image = IconLoader.getIcon(appInfo.getAboutImageUrl());
        if (appInfo.showLicenseeInfo()) {
          final InfoSurface infoSurface = new InfoSurface(image, showDebugInfo);
          //图片宽 640
          infoSurface.setPreferredSize(new Dimension(image.getIconWidth(), image.getIconHeight()));
          panel.setInfoSurface(infoSurface);
        }
        ...
        //居中
        RelativePoint location;
        if (window != null) {
          Rectangle r = window.getBounds();
          location = new RelativePoint(window, new Point((r.width - image.getIconWidth()) / 2, (r.height - image.getIconHeight()) / 2));
        }
    
    com.intellij.ide.actions.AboutPopup.InfoSurface#createTextRenderer
    
        @NotNull
        private TextRenderer createTextRenderer(Graphics2D g) {
          Rectangle r = getTextRendererRect();
          return new TextRenderer(r.x, r.y, r.width, r.height, g);
        }

        protected JBRectangle getTextRendererRect() {
          return new JBRectangle(115, 156, 500, 220);
        }
    com.intellij.ide.actions.AboutPopup.InfoSurface.TextRenderer#TextRenderer
        TextRenderer(final int xBase, final int yBase, final int w, final int h, final Graphics2D g2) {
            this.xBase = xBase;
            this.yBase = yBase;
            //赋值 500
            this.w = w;
            ...
        }
        
因此，只要宽度超过 500 即可。
因为有两行，那么，只要每行超过 250 即可。
