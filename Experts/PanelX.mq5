//+------------------------------------------------------------------+
//|                                                                  PanelX.mq5 |
//|                    Copyright 2023, Manuel Alejandro Cercos Perez |
//|                                          https://www.mql5.com/alexcercos |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Manuel Alejandro Cercos Perez"
#property link      "https://www.mql5.com/alexcercos"
#property version   "1.00"

#include <PanelX\Basis.mqh>
#include <PanelX\Window.mqh>
#include <PanelX\Currency.mqh>


//+------------------------------------------------------------------+
//| Входные параметры советника                                      |
//+------------------------------------------------------------------+
// окно //
input int      PanelWidth        = 1000;        // Ширина панели (пиксели)
input int      PanelHeight       = 1000;        // Высота панели (пиксели)
input color    PanelBgColor      = C'20,20,20'; // Цвет фона панели (темно-серый)
input color    PanelHeaderColor  = C'10,10,10'; // Цвет верхней полосы (очень темный)
input int      HeaderHeight      = 20;          // Высота заголовка (пиксели)
input int      ContentPadding    = 10;          // Внутренний отступ контента (пиксели)


CProgram program;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // 1. Создаем главную панель
   CRaiseElement* panel = new CRaiseElement(
      0,                     // ID элемента
      PanelWidth,            // Ширина
      PanelHeight,           // Высота 
      ContentPadding         // Внутренний отступ
   );
   
   // 2. Устанавливаем позицию панели
   int max_x = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS) - PanelWidth;
   int max_y = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS) - PanelHeight;
   panel.SetPosition(max_x / 2, max_y / 2);
   
   // 3. Создаем кнопки как дочерние элементы
   CCurrencyButton* btn1 = new CCurrencyButton("EURUSD", 50, 50, 100, 30);
   CCurrencyButton* btn2 = new CCurrencyButton("GBPUSD", 50, 100, 100, 30);
   
   // 4. Явно устанавливаем родителя и программу
   btn1.SetParent(panel);
   btn2.SetParent(panel);
   btn1.SetProgram(GetPointer(program));
   btn2.SetProgram(GetPointer(program));
   
   // 5. Создаем графические объекты
   panel.Create();
   btn1.Create();
   btn2.Create();
   
   // 6. Добавляем в программу только панель (кнопки уже как дочерние)
   program.AddMainElement(panel);
   
   // 7. Принудительная отрисовка
   ChartRedraw(0);
   
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer(void)
{
   program.OnTimer();
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   // 1. Обрабатываем клики по нашим кнопкам
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(StringFind(sparam, "MyButton_") == 0) // Проверяем наши кнопки
      {
         // Обработка клика по кнопке
         return; // Не передаем событие дальше
      }
   }
   
   // 2. Передаем события в PanelX
   program.OnChartEvent(id, lparam, dparam, sparam);
   
   // 3. Всегда разрешаем управление графиком
   ChartSetInteger(0, CHART_MOUSE_SCROLL, true);
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
}



//+------------------------------------------------------------------+
