﻿
//Процедура СоздатьДокументИзОстатковРСБУ(Организация, ДатаОстатков, ПутьКФайлу, ВидОперации) Экспорт
//	
//	ФормаОбработки = ЭтотОбъект.ПолучитьФорму("Форма");
//	Индикатор = ФормаОбработки.ЭлементыФормы.Индикатор1;
//	Индикатор.ОтображатьПроценты = Истина;
//	
//	Если ПутьКФайлу <> "" Тогда
//		
//		Попытка
//			Эксель = Новый COMОбъект("Excel.Application");
//		Исключение
//			Сообщить("Не создать объект. Проверьте - установлен ли Excel");
//		КонецПопытки;
//		
//		Книга = Эксель.Workbooks.Add();
//		Лист = Книга.WorkSheets(1);
//		Лист.Columns.ColumnWidth = 15;
//		Лист.Range("A1:I1").Font.Bold = Истина;
//		Лист.Range("A1:A30000").NumberFormat = "@";
//		
//		
//		Лист.Cells(1,1).Value  = "Счет РСБУ";
//		Лист.Cells(1,2).Value  = "Субконто1 РСБУ";
//		Лист.Cells(1,3).Value  = "Субконто2 РСБУ";
//		Лист.Cells(1,4).Value  = "Субконто3 РСБУ";
//		Лист.Cells(1,5).Value  = "Счет МСФО";
//		Лист.Cells(1,6).Value  = "Субконто1 МСФО";
//		Лист.Cells(1,7).Value  = "Субконто2 МСФО";
//		Лист.Cells(1,8).Value  = "Субконто3 МСФО";
//		Лист.Cells(1,9).Value  = "Сумма МСФО";
//		
//	КонецЕсли;
//	
//	ДокументОперация = Документы.бит_ОперацияУправленческий.СоздатьДокумент();
//	ДокументОперация.Дата = ДатаОстатков;
//	ДокументОперация.Организация = Организация;
//	ДокументОперация.РегистрБухгалтерии = Справочники.бит_ОбъектыСистемы.НайтиПоКоду("000001024");
//	ДокументОперация.ВидОперации = ЭтотОбъект.ПолучитьФорму("Форма").ЭлементыФормы.ВидОперацииСтрОдин.Значение;





//	ДокументОперация.Записать();
//	ФормаДокумента = ДокументОперация.ПолучитьФорму("ФормаДокумента");
//	ТаблицаПроводок = ФормаДокумента.ЭлементыФормы.ТабличноеПолеДвижениябит_Дополнительный_2.Значение;
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = "ВЫБРАТЬ
//	               |	ХозрасчетныйОстатки.Счет,
//	               |	ХозрасчетныйОстатки.Субконто1,
//	               |	ХозрасчетныйОстатки.Субконто2,
//	               |	ХозрасчетныйОстатки.Субконто3,
//	               |	ХозрасчетныйОстатки.Организация,
//	               |	ХозрасчетныйОстатки.СуммаОстаток,
//	               |	ХозрасчетныйОстатки.Подразделение,
//	               |	ХозрасчетныйОстатки.Валюта,
//	               |	ХозрасчетныйОстатки.ВалютнаяСуммаОстаток
//	               |ИЗ
//	               |	РегистрБухгалтерии.Хозрасчетный.Остатки(&ДатаОстатков, , , Организация = &Организация) КАК ХозрасчетныйОстатки";	
//	//***БИТ***Теплова***(2012.04.10			   
//	//Запрос.УстановитьПараметр("ДатаОстатков", КонецДня(ДатаОстатков)+1);
//	Запрос.УстановитьПараметр("ДатаОстатков", КонецДня(ДатаОстатков)); 
//	//***БИТ***Теплова***)
//	Запрос.УстановитьПараметр("Организация", Организация);
//	Если Счет <> ПланыСчетов.Хозрасчетный.ПустаяСсылка() Тогда
//		Запрос.УстановитьПараметр("Счет", Счет);
//		Запрос.Текст = СтрЗаменить(Запрос.Текст, "РегистрБухгалтерии.Хозрасчетный.Остатки(&ДатаОстатков, , , Организация = &Организация)", "РегистрБухгалтерии.Хозрасчетный.Остатки(&ДатаОстатков, Счет = &Счет, , Организация = &Организация)"); 
//	КонецЕсли;	
//	Выборка = Запрос.Выполнить().Выбрать();
//	
//	Индикатор.Значение = 0;
//	Индикатор.МаксимальноеЗначение = Выборка.Количество();
//	
//	ИмяИсточника = "Хозрасчетный";
//	ИмяПриемника = "бит_Дополнительный_2";	
//	КодПравилТрансляции = бит_МеханизмТрансляции.ПолучитьПравилаИКэш(Организация
//												                    ,ИмяИсточника
//												                    ,ИмяПриемника
//																	,ДокументОперация);  
//																	
//	СчетчикСтрок = 1;																	
//	Пока Выборка.Следующий() Цикл
//		
//		Если Выборка.Счет.Забалансовый Тогда
//			Индикатор.Значение = Индикатор.Значение +1;
//			Продолжить;
//		КонецЕсли;
//		
//		Параметры = Новый Структура;
//		Параметры.Вставить("СчетДт", Выборка.Счет);
//		Параметры.Вставить("СчетКт", Выборка.Счет);
//		Параметры.Вставить("СубконтоДт1", Выборка.Субконто1);
//		Параметры.Вставить("СубконтоДт2", Выборка.Субконто2);
//		Параметры.Вставить("СубконтоДт3", Выборка.Субконто3);
//		Параметры.Вставить("СубконтоКт1", Выборка.Субконто1);
//		Параметры.Вставить("СубконтоКт2", Выборка.Субконто2);
//		Параметры.Вставить("СубконтоКт3", Выборка.Субконто3);
//		Параметры.Вставить("Сумма", Выборка.СуммаОстаток);
//		Параметры.Вставить("ПодразделениеДт", Выборка.Подразделение);
//		Параметры.Вставить("ПодразделениеКт", Выборка.Подразделение);
//		Параметры.Вставить("СчетчикСтрок", СчетчикСтрок);
//		Отказ = Ложь;
//		ЗаписьПриемникСтруктура = бит_МеханизмТрансляции.ВыполнитьПодборСчетаПоПравилам(Параметры
//																						,Организация
//																						,ИмяИсточника
//																						,ИмяПриемника
//																						,ДокументОперация
//																						,КодПравилТрансляции
//																						,Отказ);
//	    																				
//																				
//	    																				
//		ЗаписьПриемник = ЗаписьПриемникСтруктура.ЗаписьПриемник;
//		Отказ          = ЗаписьПриемникСтруктура.Отказ;
//		
//		Если Отказ = Истина Тогда
//			Индикатор.Значение = Индикатор.Значение +1;
//			Продолжить;
//		КонецЕсли;
//		
//		Если ЗначениеЗаполнено(Выборка.СуммаОстаток) Тогда
//			Если Выборка.СуммаОстаток >=0 Тогда
//				СчетМСФО = ЗаписьПриемник.СчетДт;
//				ДтКт = "Дт";
//			Иначе
//				СчетМСФО = ЗаписьПриемник.СчетКт;
//				ДтКт = "Кт";
//			КонецЕсли;
//		Иначе
//			Сообщить("Проверьте сумму остатка для счета: "+ Выборка.Счет)
//		КонецЕсли;
//		
//		Если СчетМСФО = ПланыСчетов.бит_Дополнительный_2.ПустаяСсылка() Тогда
//			Сообщить("Проверьте строку документа № " + СчетчикСтрок + ". Не заполнен СчетДт. Счет источника: " + Выборка.Счет.Код);
//		КонецЕсли;
//		
//		Если СчетМСФО.Забалансовый = Истина Тогда
//			Сообщить("Проверьте строку документа № " + СчетчикСтрок + ".Счет: " + СчетМСФО.Код + " - забалансовый. Исключен из документа.");
//		КонецЕсли;
//		
//		НоваяПроводка = ТаблицаПроводок.Добавить();
//		
//		Если ЗначениеЗаполнено(СчетМСФО) Тогда
//			НоваяПроводка.СчетДт = СчетМСФО;
//		КонецЕсли;
//		НоваяПроводка.СчетКт = ПланыСчетов.бит_Дополнительный_2.Служебный;
//		НоваяПроводка.СуммаРегл = Выборка.СуммаОстаток;
//		НоваяПроводка.СуммаУпр  = Выборка.СуммаОстаток;
//		НоваяПроводка.СуммаМУ   = Выборка.СуммаОстаток;
//		НоваяПроводка.ВидДвиженияМСФО = Перечисления.БИТ_ВидыДвиженияМСФО.РСБУ;
//		
//		Если Выборка.Счет.Валютный = Истина Тогда
//			НоваяПроводка.ВалютаДт = Выборка.Валюта; 	
//			НоваяПроводка.ВалютнаяСуммаДт = Выборка.ВалютнаяСуммаОстаток;
//		КонецЕсли;
//		
//		СубконтоМСФОСоотв = Новый Соответствие;
//		НомерСубконто = 1;
//	 	Для Каждого ТекущееСубконто Из ЗаписьПриемник["Субконто" + ДтКт] Цикл
//			Если ЗначениеЗаполнено(ТекущееСубконто) Тогда
//				НоваяПроводка.СубконтоДт.Вставить(ТекущееСубконто.Ключ, ТекущееСубконто.Значение);
//				СубконтоМСФОСоотв.Вставить(НомерСубконто, ТекущееСубконто.Значение);
//				НомерСубконто = НомерСубконто + 1;
//			КонецЕсли;
//		КонецЦикла;
//		
//		Если ПутьКФайлу <> "" Тогда
//			Лист.Cells(СчетчикСтрок +1 ,1).Value  = Параметры.СчетДт.Код;
//			Лист.Cells(СчетчикСтрок +1 ,2).Value  = ?(Параметры.СубконтоДт1 = Null, "", Строка(Параметры.СубконтоДт1));
//			Лист.Cells(СчетчикСтрок +1 ,3).Value  = ?(Параметры.СубконтоДт2 = Null, "", Строка(Параметры.СубконтоДт2));
//			Лист.Cells(СчетчикСтрок +1 ,4).Value  = ?(Параметры.СубконтоДт3 = Null, "", Строка(Параметры.СубконтоДт3));
//			Лист.Cells(СчетчикСтрок +1 ,5).Value  = СчетМСФО.Код;
//			
//			Для Каждого Элемент Из СубконтоМСФОСоотв Цикл
//				Лист.Cells(СчетчикСтрок +1, 5+Элемент.Ключ).Value = ?(Элемент.Значение = Null, "", Строка(Элемент.Значение));
//			КонецЦикла;
//			
//			Лист.Cells(СчетчикСтрок +1 ,9).Value  = Выборка.СуммаОстаток;
//		КонецЕсли;
//		
//		СчетчикСтрок = СчетчикСтрок + 1;
//		Индикатор.Значение = Индикатор.Значение +1;
//	КонецЦикла; 
//	
//	
//	Если ПутьКФайлу <> "" Тогда
//		Книга.SaveAs(ПутьКФайлу);
//		Эксель.Application.Quit();
//	КонецЕсли;

//	ФормаДокумента.Открыть();
//	ПересчитатьСуммуОперации(ДокументОперация);
//	//////Предупреждение("Документ еще не записан. После проверки, нажмите Записать", 10, "Предупреждение");
//КонецПроцедуры

//Процедура ПересчитатьСуммуОперации(Документ)
//	ИмяРегистраБухгалтерии = "бит_Дополнительный_2";
//	ЭлементыФормы = Документ.ПолучитьФорму("ФормаДокумента").ЭлементыФормы;
//	Документ.СуммаОперацииМУ   = 0;

//	Для Каждого Проводка Из ЭлементыФормы["ТабличноеПолеДвижения" + ИмяРегистраБухгалтерии].Значение Цикл
//			
//		Документ.СуммаОперацииМУ = Документ.СуммаОперацииМУ + Проводка.СуммаМУ;
//				
//	КонецЦикла;

//КонецПроцедуры // ПересчитатьСуммуОперации()

