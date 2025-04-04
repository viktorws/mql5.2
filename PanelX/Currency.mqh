//+------------------------------------------------------------------+
//|                                                     Currency.mqh |
//|                    Copyright 2023, Manuel Alejandro Cercos Perez |
//|                                  https://www.mql5.com/alexcercos |
//+------------------------------------------------------------------+
#include <PanelX\DragElement.mqh>

//+------------------------------------------------------------------+
//| Кнопка валюты с полной функциональностью                        |
//+------------------------------------------------------------------+
class CCurrencyButton : public CDragElement
{
private:
   string            m_currency;
   color             m_bg_color;
   color             m_text_color;
   color             m_border_color;
   bool              m_is_pressed;

protected:
   virtual void      DrawCanvas();
   virtual bool      OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam);

public:
                     CCurrencyButton(string currency, int x, int y, int width, int height);
   virtual void      Create();
   void              SetColors(color bg, color text, color border);
   void              SetPressedState(bool pressed);
};

//+------------------------------------------------------------------+
//| Конструктор                                                     |
//+------------------------------------------------------------------+
CCurrencyButton::CCurrencyButton(string currency, int x, int y, int width, int height) :
   m_currency(currency),
   m_bg_color(C'30,30,30'),
   m_text_color(clrWhite),
   m_border_color(clrSilver),
   m_is_pressed(false)
{
   SetPosition(x, y);
   SetSize(width, height);
   // Убрали BlockChartEvents, так как это должно управляться извне
}

//+------------------------------------------------------------------+
//| Создание графического объекта                                   |
//+------------------------------------------------------------------+
void CCurrencyButton::Create()
{
   CDragElement::Create();
   if(!m_canvas.CreateBitmapLabel(0, 0, m_name, GetGlobalX(), GetGlobalY(), m_size_x, m_size_y, COLOR_FORMAT_ARGB_NORMALIZE))
      Print("Ошибка создания кнопки ", m_name);
   DrawCanvas();
}

//+------------------------------------------------------------------+
//| Установка цветов                                                |
//+------------------------------------------------------------------+
void CCurrencyButton::SetColors(color bg, color text, color border)
{
   m_bg_color = bg;
   m_text_color = text;
   m_border_color = border;
   DrawCanvas();
}

//+------------------------------------------------------------------+
//| Установка состояния нажатия                                     |
//+------------------------------------------------------------------+
void CCurrencyButton::SetPressedState(bool pressed)
{
   if(m_is_pressed != pressed)
   {
      m_is_pressed = pressed;
      DrawCanvas();
   }
}

//+------------------------------------------------------------------+
//| Обработка событий                                               |
//+------------------------------------------------------------------+
bool CCurrencyButton::OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == m_name)
   {
      SetPressedState(!m_is_pressed);
      return true;
   }
   return CDragElement::OnEvent(id, lparam, dparam, sparam);
}

//+------------------------------------------------------------------+
//| Отрисовка кнопки                                                |
//+------------------------------------------------------------------+
void CCurrencyButton::DrawCanvas(void)
{
   // Заливка фона с учетом состояния
   color current_bg = m_is_pressed ? ChangeColorBrightness(m_bg_color, -30) : m_bg_color;
   m_canvas.Erase(current_bg);
   
   // Рисуем рамку
   m_canvas.Rectangle(0, 0, m_size_x-1, m_size_y-1, ColorToARGB(m_border_color));
   
   // Настройки шрифта
   m_canvas.FontSet("Arial", -12, FW_NORMAL);
   
   // Рассчет позиции текста
   int text_width = m_canvas.TextWidth(m_currency);
   int text_height = m_canvas.TextHeight(m_currency);
   
   // Вывод текста
   m_canvas.TextOut(
      (m_size_x - text_width)/2, 
      (m_size_y - text_height)/2, 
      m_currency, 
      m_text_color
   );
   
   m_canvas.Update(false);
}

//+------------------------------------------------------------------+
//| Изменение яркости цвета                                         |
//+------------------------------------------------------------------+
color ChangeColorBrightness(color clr, int delta)
{
   int r = (clr & 0xFF) + delta;
   int g = ((clr >> 8) & 0xFF) + delta;
   int b = ((clr >> 16) & 0xFF) + delta;
   
   r = MathMin(MathMax(r, 0), 255);
   g = MathMin(MathMax(g, 0), 255);
   b = MathMin(MathMax(b, 0), 255);
   
   return (color)(r | (g << 8) | (b << 16));
}
//+------------------------------------------------------------------+