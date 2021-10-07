﻿
#Область ПрограммныйИнтерфейс

// Процедура заполняет план счетов из документа MS Excel.
//
// Параметры:
//  ИмяПланаСчетов	 - Строка	 - Имя плана счетов.
//
Процедура ЗаполнитьПланСчетовИзЭксель(ИмяПланаСчетов) Экспорт
	
	# Если ВебКлиент Тогда 
		ВызватьИсключение НСтр("ru = 'Работа с файлами Excel в режиме Веб-клиента недоступна.'");
	# КонецЕсли

	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Фильтр = "Все файлы Excel (*.xls, *.xlsx)|*.xls; *.xlsx";

	Дополнительно = Новый Структура("ИмяПланаСчетов", ИмяПланаСчетов); 
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПланСчетовИзЭксельЗавершение", ЭтотОбъект, Дополнительно); 
	ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(Оповещение, Диалог);
	
КонецПроцедуры

// Процедура обработчик оповещения "ЗаполнитьПланСчетовИзЭксельЗавершение".
//
// Параметры:
//  ВыбранныеФайлы			 - Массив	 - Имена выбранных файлов.
//  ДополнительныеПараметры	 - 			 - Структура.
//
Процедура ЗаполнитьПланСчетовИзЭксельЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	// Открытие эксель
	ПолноеИмя = ВыбранныеФайлы[0];
	Отказ 	  = Ложь;		
	Эксель 	  = бит_ОбменДаннымиЭксельКлиентСервер.InitExcel(Ложь, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	ИмяПланаСчетов = ДополнительныеПараметры.ИмяПланаСчетов;

	ЭксельКнига = бит_ОбменДаннымиЭксельКлиентСервер.OpenExcelFile(Эксель, ПолноеИмя, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Лист = бит_ОбменДаннымиЭксельКлиентСервер.GetExcelSheet(ЭксельКнига, 1, Отказ);
	
	ИмяЛистаИсточник = бит_ПроформыКлиентСервер.ListSourceSheetName();
	Попытка
		ЛистИсточникСписков = Эксель.Sheets(ИмяЛистаИсточник);
		//ЕстьСписки = Истина;
		// Чтение источников выпадающих списков.
		СпискиИсточники = бит_ПроформыКлиентСервер.ПрочитатьСпискиИсточники(ЭксельКнига);
	Исключение
		//ЕстьСписки = Ложь;
		СпискиИсточники = Новый Соответствие;
	КонецПопытки;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ВидыСчета = Новый Соответствие;
	ВидыСчета.Вставить("А" , ВидСчета.Активный);
	ВидыСчета.Вставить("П" , ВидСчета.Пассивный);
	ВидыСчета.Вставить("АП", ВидСчета.АктивноПассивный);
	
	ПоляСтруктуры = бит_БухгалтерияКлиентСервер.ОпределитьСтрокуПолейПланаСчетов(ИмяПланаСчетов);
	
	МассивПолей = бит_СтрокиКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПоляСтруктуры);				 
	МассивСтрокДляЗаполнения = Новый Массив;
	
	КоличествоСтолбцов = МассивПолей.Количество();
	Сч   = 2;
	СчАп = 0;
	// Наименование всегда заполнено, поэтому опираемся на него.
	ДанныеЯчейки = Лист.Cells(Сч,4).Value;
	ЕстьДанные = ТипЗнч(ДанныеЯчейки) = Тип("Строка") 
	И ЗначениеЗаполнено(ДанныеЯчейки);
	
	Пока ЕстьДанные Цикл
		
		СтруктураСтроки = Новый Структура(ПоляСтруктуры);
		
		Для каждого ИмяПоля Из МассивПолей Цикл
			
			Индекс = МассивПолей.Найти(ИмяПоля);
			
			//// Проверка имени колонки в Excel.
			//Пока ИмяПоля <> Лист.Cells(1,Индекс+1).Value Цикл
			//    Индекс = Индекс + 1;                
			//КонецЦикла;
			
			ЗначениеЯчейки = Лист.Cells(Сч,Индекс+1).Value;
			
			Если ИмяПоля = "Вид" Тогда
				ЗначениеСчета 	= ВРег(ЗначениеЯчейки);
				ТекущийВид 		= ВидыСчета[ЗначениеСчета];	
				Значение 		= ?(ТекущийВид = Неопределено, ВидСчета.АктивноПассивный, ТекущийВид);
			ИначеЕсли ИмяПоля  = "Забалансовый" 
				ИЛИ ИмяПоля = "Валютный" 
				ИЛИ ИмяПоля = "Количественный"
				ИЛИ ИмяПоля = "ОбСубконто1"
				ИЛИ ИмяПоля = "ОбСубконто2"
				ИЛИ ИмяПоля = "ОбСубконто3"
				ИЛИ ИмяПоля = "ОбСубконто4"
				ИЛИ ИмяПоля = "ИспользоватьИсторическиеКурсы"
				ИЛИ ИмяПоля = "ПометкаУдаления" Тогда	
				Значение = ОпределитьЗначениеБулевогоТипа(Строка(ЗначениеЯчейки));	  
			ИначеЕсли ИмяПоля = "Субконто1"
				ИЛИ ИмяПоля = "Субконто2"
				ИЛИ ИмяПоля = "Субконто3"
				ИЛИ ИмяПоля = "Субконто4" Тогда
				
				
				СписокИсточникExcel = СпискиИсточники.Получить("СписокВидыСубконто");
				Если СписокИсточникExcel <> Неопределено Тогда
					
					СтруктураЗначенияExcel = СписокИсточникExcel.Получить(ЗначениеЯчейки);
					Если СтруктураЗначенияExcel <> Неопределено Тогда                            
						ЗначениеСсылка = СтруктураЗначенияExcel.Ссылка;
						ИмяСписка = Лев(ЗначениеСсылка, Найти(ЗначениеСсылка, "/")-1);
						Значение = бит_ОбменДаннымиЭксельСервер.ПолучитьЗначениеПоСсылкеExcel(ЗначениеСсылка, 
						ИмяСписка, 
						ЗначениеЯчейки);               	      					
					Иначе                            
						Значение = ?(ТипЗнч(ЗначениеЯчейки) = Тип("Число"), Формат(ЗначениеЯчейки, "ЧГ=15"), СокрЛП(ЗначениеЯчейки));                            
					КонецЕсли;
					
				КонецЕсли;     
			Иначе
				Значение = ?(ТипЗнч(ЗначениеЯчейки) = Тип("Число"), Формат(ЗначениеЯчейки, "ЧГ=15"), СокрЛП(ЗначениеЯчейки));
			КонецЕсли;	
			
			СтруктураСтроки.Вставить(ИмяПоля, Значение);
			
		КонецЦикла; 
		
		МассивСтрокДляЗаполнения.Добавить(СтруктураСтроки);
		
		Сч   = Сч + 1;
		СчАп = СчАп + 1;
		
		ДанныеЯчейки = Лист.Cells(Сч,4).Value;
		ЕстьДанные = ТипЗнч(ДанныеЯчейки) = Тип("Строка") 
		И ЗначениеЗаполнено(ДанныеЯчейки);
		
		// Проверка на зацикливание.
		Если СчАп > 30000 Тогда				
			Прервать;  			
		КонецЕсли; 
		
	КонецЦикла; 
	
	// Закрытие Excel
	бит_ОбменДаннымиЭксельКлиентСервер.CloseExcelFile(ЭксельКнига, Ложь);
	бит_ОбменДаннымиЭксельКлиентСервер.QuitExcel(Эксель);		
	
	бит_БухгалтерияСервер.ЗаполнитьПланСчетовПоУмолчанию(ИмяПланаСчетов, МассивСтрокДляЗаполнения);
	
	ОповеститьОбИзменении(Тип("ПланСчетовСсылка." + ИмяПланаСчетов));
	
КонецПроцедуры

// Осуществляет выгрузку шаблона плана счетов в Excel.
//
// Параметры:
//  ИмяПланаСчетов	 - Строка	 - Имя плана счетов.
//  МассивДанных	 - Массив	 - Массив с данными по плану счетов.
//  СпискиВыбора	 - Структура - Структура со списками для выгрузки.
//
&НаКлиенте
Процедура ВыгрузитьШаблонЭксель(ИмяПланаСчетов, МассивДанных, СпискиВыбора) Экспорт
	
	ТекстСостояния =  НСтр("ru = 'Выгрузка шаблона Excel...'");
	Состояние(ТекстСостояния);
	
	Отказ = Ложь;
	Excel = бит_ОбменДаннымиЭксельКлиентСервер.InitExcel(Истина, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	XlEnums = бит_ОбменДаннымиЭксельКлиентСервер.InitExcelEnums();
	
	// Определим разделитель согласно региональным настройкам и подготовим форматы.
	Разделитель = Excel.International(XlEnums.XlApplicationInternational.xlDecimalSeparator);
	ФорматСумма = "# ##0" + Разделитель + "00";
	ФорматКоличество = "# ##0" + Разделитель + "000";
	
	Wb = Excel.Application.WorkBooks.Add(1);		
	
	// Создание и установка параметров для листа, являющегося источником выпадающих списков.
	ExcelSheet = Wb.Worksheets.Add(,Wb.Worksheets(Wb.Worksheets.Count));
	ExcelSheet.Name = бит_ПроформыКлиентСервер.ListSourceSheetName();//НСтр("ru = 'Источник списков'");
	ExcelSheet.StandardWidth           = 25;
	ExcelSheet.Cells.WrapText          = Истина;
	ExcelSheet.Cells.VerticalAlignment = XlEnums.xlConsts.xlCenter;
	ExcelSheet.Cells.NumberFormat      = "@";
	
	СтСтрока = 1;
	СтКолонка = 1;
	СчН=0;
	Для каждого Список Из СпискиВыбора Цикл
		
		ТекКолонка = СтКолонка + СчН;			
		
		Cell = ExcelSheet.Cells(СтСтрока, ТекКолонка);
		Cell.Value = Список.Ключ;
		
		СчК=1;
        Если ТипЗнч(Список.Значение) = Тип("Массив") Тогда
        
            Для каждого Эл Из Список.Значение Цикл			
    			ТекСтрока = СтСтрока + СчК;    			
    			Cell = ExcelSheet.Cells(ТекСтрока, ТекКолонка);
    			Cell.Value = Эл;    			
    			СчК = СчК+1;    			
    		КонецЦикла;	
        
        Иначе
        
        	Для каждого Эл Из Список.Значение Цикл			
    			ТекСтрока = СтСтрока + СчК;    			
    			Cell = ExcelSheet.Cells(ТекСтрока, ТекКолонка);
    			Cell.Value = Эл.Представление;
                Cell = ExcelSheet.Cells(ТекСтрока, ТекКолонка+1);
    			Cell.Value = Эл.Значение;
    			СчК = СчК+1;    			
    		КонецЦикла;
        
        КонецЕсли;
		 
		
		PosStart = бит_ОбменДаннымиЭксельКлиентСервер.CellPosition(СтСтрока+1,ТекКолонка);
		PosEnd   = бит_ОбменДаннымиЭксельКлиентСервер.CellPosition(ТекСтрока,ТекКолонка);			
		Selection = ExcelSheet.Range(ExcelSheet.Cells(PosStart.Row, PosStart.Column),ExcelSheet.Cells(PosEnd.Row, PosEnd.Column));
		Selection.Name = Список.Ключ;
		
		СчН=СчН+2;
		
	КонецЦикла; 
	
	// Закрепим шапку.
	Selection = ExcelSheet.Range(ExcelSheet.Cells(2, 1), ExcelSheet.Cells(2, 1)).Select();
	Excel.Application.ActiveWindow.FreezePanes = True;
	
	// Лист для плана счетов
	ExcelSheet = Wb.Worksheets.Add(Wb.Worksheets(Wb.Worksheets.Count));
	ExcelSheet.Name =  НСтр("ru = 'План счетов'");
	ExcelSheet.StandardWidth = 15;
	ExcelSheet.Cells.NumberFormat = "@";
	
	// Структура полей
    СтруктураПолей = бит_БухгалтерияКлиентСервер.ОпределитьСтруктуруПолейПланаСчетов(ИмяПланаСчетов);
	// Списки номеров колонок из процедуры бит_БухгалтерияКлиентСервер.ОпределитьСтруктуруПолей(ИмяПланаСчетов).
	Если ИмяПланаСчетов = "бит_Дополнительный_2" Тогда       
		// 1-РодительКод,2-Код,3-Порядок,4-Наименование,5-НаименованиеПолное,
		// 6-Вид,7-Забалансовый,8-Валютный,9-Количественный,10-ИспользоватьИсторическиеКурсы,11-Группа,
		// 12-Субконто1,13-ОбСубконто1,14-Субконто2,15-ОбСубконто2,16-Субконто3,
		// 17-ОбСубконто3,18-Субконто4,19-ОбСубконто4,
		// 20-ПометкаУдаления.
	 	СписокНомеровБулево   = "7,8,9,10,11,13,15,17,19,20";
		СписокНомеровСубконто = "12,14,16,18";
		Н_ВидСчета	 		  = 6;
	Иначе
		// 1-РодительКод,2-Код,3-Порядок,4-Наименование,5-НаименованиеПолное,
		// 6-Вид,7-Забалансовый,8-Валютный,9-Количественный,10-Группа,
		// 11-Субконто1,12-ОбСубконто1,13-Субконто2,14-ОбСубконто2,15-Субконто3,16-ОбСубконто3,
		// 17-Субконто4,18-ОбСубконто4,
		// 19-ПометкаУдаления.
		СписокНомеровБулево   = "7,8,9,10,12,14,16,18,19";
		СписокНомеровСубконто = "11,13,15,17";
		Н_ВидСчета 			  = 6;
	КонецЕсли;       
	
	// Вывод шапки.
    СчПоля = 1;
    Для каждого КлЗнчПоля Из СтруктураПолей Цикл
               
        Cell = ExcelSheet.Cells(1, СчПоля);
        		
		Cell.WrapText 	  = True;
		Cell.Font.Size 	  = 8;
		Cell.Font.Bold 	  = True;
		Cell.NumberFormat = "@";				
		Cell.Value 		  = КлЗнчПоля.Значение; // Представление;	
        
        СчПоля = СчПоля + 1;
		
	КонецЦикла; 
	
	// Закрепим шапку.
	Selection = ExcelSheet.Range(ExcelSheet.Cells(2, 1), ExcelSheet.Cells(2, 1)).Select();
	Excel.Application.ActiveWindow.FreezePanes = True;
       
	// Заполняем строки из текущего плана счетов.
	Для каждого Стр Из МассивДанных Цикл
		
		ИндексСтроки = МассивДанных.Найти(Стр)+1;
        
        СчПоля = 1;        
        Для каждого КлЗнчПоля Из СтруктураПолей Цикл
        
            ИмяПоля = КлЗнчПоля.Ключ;
            
            Cell = ExcelSheet.Cells(ИндексСтроки+1, СчПоля);
			
			Cell.WrapText  = True;
			Cell.Font.Size = 8;
			Cell.Value 	   = Строка(Стр[ИмяПоля]);			
            
            СчПоля = СчПоля + 1;
            
		КонецЦикла; 
	
	КонецЦикла; 
	
	НомПервойСтроки = 1;
	КолСтрок   = МассивДанных.Количество()+1;
    КолКолонок = СтруктураПолей.Количество();
		
	// Установка области для списка видов счетов.
	Selection = ExcelSheet.Range(ExcelSheet.Cells(НомПервойСтроки+1, Н_ВидСчета),ExcelSheet.Cells(КолСтрок+100, Н_ВидСчета));
	бит_ОбменДаннымиЭксельКлиентСервер.SetList(Selection, "СписокВидСчета", XlEnums);
        
	// Установка областей для списка Булево.
	МассивНомеров = бит_СтрокиКлиентСервер.РазложитьСтрокуВМассивПодстрок(СписокНомеровБулево);				 
	Для каждого Номер Из МассивНомеров Цикл
	
		Selection = ExcelSheet.Range(ExcelSheet.Cells(НомПервойСтроки+1, Число(Номер)),ExcelSheet.Cells(КолСтрок+100, Число(Номер)));
		бит_ОбменДаннымиЭксельКлиентСервер.SetList(Selection, "СписокДаНет", XlEnums);
	
	КонецЦикла;
	
	// Установка областей для списка субконто.
	МассивНомеров = бит_СтрокиКлиентСервер.РазложитьСтрокуВМассивПодстрок(СписокНомеровСубконто);				 
	Для каждого Номер Из МассивНомеров Цикл
	
		Selection = ExcelSheet.Range(ExcelSheet.Cells(НомПервойСтроки+1, Число(Номер)),ExcelSheet.Cells(КолСтрок+100, Число(Номер)));
		бит_ОбменДаннымиЭксельКлиентСервер.SetList(Selection, "СписокВидыСубконто", XlEnums);
	
	КонецЦикла;
	
	// Установка сетки
	posStart  = бит_ОбменДаннымиЭксельКлиентСервер.CellPosition(НомПервойСтроки,1);
	PosEnd    = бит_ОбменДаннымиЭксельКлиентСервер.CellPosition(КолСтрок+1,КолКолонок);
	бит_ОбменДаннымиЭксельКлиентСервер.SetBorderLines(ExcelSheet, XlEnums ,posStart ,PosEnd); 
	
	Excel.Visible = Истина;
	
	// Лист "по-умолчанию" удаляем.
	Wb.Worksheets(1).Delete();		
	
	ТекстСостояния =  НСтр("ru = 'Выгрузка шаблона Excel завершена.'");
	Состояние(ТекстСостояния);
	
КонецПроцедуры // ВыгрузитьШаблонЭксель()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция определяет значение для булевого типа.
//
// Возвращаемое значение:
//  Значение - Булево.
//
Функция ОпределитьЗначениеБулевогоТипа(ЗначениеЯчейки)

	Значение = ?(ЗначениеЯчейки = "1"
	            ИЛИ ВРег(ЗначениеЯчейки) = "ДА"
				ИЛИ ВРег(ЗначениеЯчейки) = "ИСТИНА"
				, Истина
				, Ложь);	  

	Возврат Значение;
	
КонецФункции // ОпределитьЗначениеБулевогоТипа()

#КонецОбласти
