﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем мТекущийВидСравнения; // Служит для передачи вида сравнения между обработчиками.

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьКэшЗначений();
	
	Если Параметры.Свойство("СтрТип") Тогда
		
		// Инициализация построителя
		ТекстЗапроса = Справочники.бит_ВидыПроформ.ПодготовитьТекстЗапросаДляВыгрузки(Параметры.СтрТип);
		
	КонецЕсли; 
	
	Если Параметры.Свойство("СтруктураНастроек") Тогда
		
		// Восстановление сохраненных отборов и порядка.
		СтруктураНастроек = Параметры.СтруктураНастроек;
		
		Если СтруктураНастроек.Свойство("Отбор") Тогда
		
			Для каждого Элемент Из СтруктураНастроек.Отбор Цикл
			
				НоваяСтрока = ТаблицаОтбор.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Элемент);
			
			КонецЦикла; 
		
		КонецЕсли; 
		
		Если СтруктураНастроек.Свойство("Порядок") Тогда
		
			Для каждого Элемент Из СтруктураНастроек.Порядок Цикл
			
				НоваяСтрока = ТаблицаПорядок.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Элемент);
			
			КонецЦикла; 
		
		КонецЕсли; 
		
	КонецЕсли; 
	
    бит_МеханизмПолученияДанных.УстановитьОформлениеТаблицыОтбор(УсловноеОформление);		
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаОтбор

&НаКлиенте
Процедура ТаблицаОтборПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока Тогда
		
	  ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;		
		
	  Если Копирование Тогда
	  
		ТекущаяСтрока.ПутьКДанным = "";
		
	  Иначе
		  
		ТекущаяСтрока.Использование  = Истина;  
		ТекущаяСтрока.ВидСравнения   = фКэшЗначений.ВидСравненияРавно;
		
	  КонецЕсли; 	
		
	  ОткрытьФормуПолейПостроителя("ТаблицаОтбор", "ПутьКДанным", "Отбор");
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтборПолеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	  СтандартнаяОбработка = Ложь;
	  ОткрытьФормуПолейПостроителя("ТаблицаОтбор", "ПутьКДанным", "Отбор");
	  
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтборВидСравненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;
	
	СписокВидов = СписокВыбораВидаСравнения(ТекущаяСтрока.ПолучитьИдентификатор());
	
	Элемент.СписокВыбора.Очистить();
	
	Для каждого Эл Из СписокВидов Цикл
	
		Элемент.СписокВыбора.Добавить(Эл.Значение, Эл.Представление);
	
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтборВидСравненияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;
	ИзменениеВидаСравнения(ТекущаяСтрока.ПолучитьИдентификатор(),мТекущийВидСравнения);
	
КонецПроцедуры

// Процедура обрабатывает изменение вида сравнения.
// 
// Параметры:
//  ИдСтроки         - Строка
//  ПредВидСравнения - ВидСравнения.
// 
&НаСервере
Процедура ИзменениеВидаСравнения(ИдСтроки,ПредВидСравнения)
	
	ТекущаяСтрока = ТаблицаОтбор.НайтиПоИдентификатору(ИдСтроки);
	
	бит_МеханизмПолученияДанных.ИзменениеВидаСравнения(ТекущаяСтрока, ПредВидСравнения);
		
КонецПроцедуры // ИзменениеВидаСравнения()

// Функция возвращает список доступных видов сравнения в зависимости от типа значения в строке.
// 
// Параметры:
//  ИдСтроки - Число.
// 
&НаСервере
Функция СписокВыбораВидаСравнения(ИдСтроки)
	
	ТекущаяСтрока = ТаблицаОтбор.НайтиПоИдентификатору(ИдСтроки);
	СписокВидов = бит_МеханизмПолученияДанных.СписокВыбораВидаСравнения(ТекущаяСтрока);
	
    Возврат СписокВидов;
	
КонецФункции // СписокВыбораВидаСравнения()

&НаКлиенте
Процедура ТаблицаОтборЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;
	
	Оповещение = Новый ОписаниеОповещения("ТаблицаОтборЗначениеНачалоВыбораОкончание", ЭтотОбъект); 
	
	Если ТекущаяСтрока.ЭтоПериодичность Тогда
	
		СтандартнаяОбработка = Ложь;
		
		СписокПериодичности = бит_ОбщегоНазначенияКлиентСервер.ПолучитьПериодичности();
		
		ОповещениеВыбор = Новый ОписаниеОповещения("ТаблицаОтборПоказатьВыборИзСписка", ЭтотОбъект, Оповещение);
		ПоказатьВыборИзСписка(ОповещениеВыбор, СписокПериодичности); 
		
	Иначе
		
		ВыполнитьОбработкуОповещения(Оповещение);
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура окончание процедуры "ТаблицаОтборЗначениеНачалоВыбора".
// 
&НаКлиенте 
Процедура ТаблицаОтборЗначениеНачалоВыбораОкончание(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;
	
	Если ТипЗнч(ТекущаяСтрока.ТипЗначения) = Тип("ОписаниеТипов") 
		 И ТекущаяСтрока.ТипЗначения.Типы().Количество() > 1 
		 И ТекущаяСтрока.Значение = Неопределено  Тогда
		
		Элементы.ТаблицаОтборЗначение.ВыбиратьТип = Истина;	
		Элементы.ТаблицаОтборЗначение.ОграничениеТипа = ТекущаяСтрока.ТипЗначения;
		
	Иначе	
		
		Элементы.ТаблицаОтборЗначение.ВыбиратьТип = Ложь;	
		Элементы.ТаблицаОтборЗначение.ОграничениеТипа = Новый ОписаниеТипов;		
		
	КонецЕсли; 
	
КонецПроцедуры // ТаблицаОтборЗначениеНачалоВыбораОкончание()

&НаКлиенте 
Процедура ТаблицаОтборПоказатьВыборИзСписка(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;
	
	Если НЕ РезультатВыбора = Неопределено Тогда
	
		ТекущаяСтрока.Значение = РезультатВыбора.Значение;
	
	КонецЕсли; 
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры);
	
КонецПроцедуры // ТаблицаОтборПоказатьВыборИзСписка()

&НаКлиенте
Процедура ТаблицаОтборЗначениеОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;
	
	Если ТипЗнч(ТекущаяСтрока.ТипЗначения) = Тип("ОписаниеТипов") 
		И ТекущаяСтрока.ТипЗначения.Типы().Количество() > 1 Тогда
		
		ТекущаяСтрока.Значение = Неопределено;
		
	КонецЕсли;	 
	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПорядок

&НаКлиенте
Процедура ПорядокПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока Тогда
		
	  ТекущаяСтрока = Элементы.ТаблицаПорядок.ТекущиеДанные;		
		
	  Если Копирование Тогда
	  
		ТекущаяСтрока.Имя = "";
		
	  Иначе
		
		ТекущаяСтрока.НаправлениеСортировки = фКэшЗначений.Перечисления.бит_мпд_НаправленияСортировки.Возрастание;
		
	  КонецЕсли; 	
		
	  ОткрытьФормуПолейПостроителя("ТаблицаПорядок", "ПутьКДанным", "Порядок");
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокИмяНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	  СтандартнаяОбработка = Ложь;
	  ОткрытьФормуПолейПостроителя("ТаблицаПорядок", "ПутьКДанным", "Порядок");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	СтруктураНастроек = Новый Структура;
	ПредставлениеНастроек = "";
	
	МассивОтбор = Новый Массив;
	
	Для каждого СтрокаТаблицы Из ТаблицаОтбор Цикл
		
		СтрОтбор = бит_ОбщегоНазначенияКлиентСервер.КонструкторСтруктураОтбор();
		
		ЗаполнитьЗначенияСвойств(СтрОтбор, СтрокаТаблицы);
		
		МассивОтбор.Добавить(СтрОтбор);
		
		ПредставлениеНастроек = ПредставлениеНастроек
		                         +?(ПустаяСтрока(ПредставлениеНастроек),""," / ")
								 +Строка(СтрОтбор.ПутьКДанным)
								 +" "
								 +Строка(СтрОтбор.ВидСравнения)
								 +" "
								 +Строка(СтрОтбор.Значение);
		
	КонецЦикла; 
	
	МассивПорядок = Новый Массив;
	
	Для каждого СтрокаТаблицы Из ТаблицаПорядок Цикл
	
		СтрПорядок = Новый Структура("ПутьКДанным, НаправлениеСортировки"
		                              , СтрокаТаблицы.ПутьКДанным
									  , СтрокаТаблицы.НаправлениеСортировки); 
									  
		МассивПорядок.Добавить(СтрПорядок);	
		
		ПредставлениеНастроек = ПредставлениеНастроек
		                         +?(ПустаяСтрока(ПредставлениеНастроек),""," / ")
								 +Строка(СтрПорядок.ПутьКДанным)
								 +" "
								 +Строка(СтрПорядок.НаправлениеСортировки);
								 
	
	КонецЦикла; 
	
	СтруктураНастроек.Вставить("Отбор", МассивОтбор);
	СтруктураНастроек.Вставить("Порядок", МассивПорядок);
	
	РезСтруктура = Новый Структура;
	РезСтруктура.Вставить("ПредставлениеНастроек", ПредставлениеНастроек);
	РезСтруктура.Вставить("СтруктураНастроек", СтруктураНастроек);
	РезСтруктура.Вставить("Изменено", Истина);
	
	Закрыть(РезСтруктура);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет кэш значений, для последующего использования на клиенте.
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()
	
	
	фКэшЗначений = Новый Структура;
	фКэшЗначений.Вставить("ТекущаяИнформационнаяБаза", Справочники.бит_мпд_ВидыИнформационныхБаз.ТекущаяИнформационнаяБаза);
	
	фКэшЗначений.Вставить("ВидСравненияРавно", ВидСравнения.Равно);
	
	// Перечисления
	КэшПеречисления = Новый Структура;
	
	ТекПеречисление = бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_ВидыПараметровЗапроса);
	КэшПеречисления.Вставить("бит_ВидыПараметровЗапроса",ТекПеречисление);
	
	ТекПеречисление = бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_мпд_НаправленияСортировки);
	КэшПеречисления.Вставить("бит_мпд_НаправленияСортировки",ТекПеречисление);
	
	фКэшЗначений.Вставить("Перечисления",КэшПеречисления);
	
	МассивТипов = Новый Массив();
	МассивТипов.Добавить(Тип("Строка"));
	КвСтроки = Новый КвалификаторыСтроки(500);
	ОписаниеТипаСтрока = Новый ОписаниеТипов(МассивТипов, , КвСтроки);
	фКэшЗначений.Вставить("ОписаниеТипаСтрока", ОписаниеТипаСтрока);
	фКэшЗначений.Вставить("ОписаниеПроизвольногоТипа", бит_ОбщегоНазначения.ОписаниеПроизвольногоТипа());
	
	
КонецПроцедуры // ЗаполнитьКэшЗначений() 

// Процедура открывает форму выбора полей построителя.
// 
// Параметры:
//  ИмяТабЧасти - Строка
//  ИмяПоля     - Строка
//  Режим       - Строка
// 
&НаКлиенте
Процедура ОткрытьФормуПолейПостроителя(ИмяТабЧасти, ИмяПоля, Режим)

	ТекущаяСтрока = Элементы[ИмяТабЧасти].ТекущиеДанные;
	ДополнительныеПараметры = Новый Структура("ИмяТабЧасти, ИмяПоля", ИмяТабЧасти, ИмяПоля);
	
	ПараметрыФормы  = Новый Структура;
	ПараметрыФормы.Вставить("ТекстЗапроса"         ,ТекстЗапроса);
	ПараметрыФормы.Вставить("ИнициализироватьПостроитель", Истина);	
	ПараметрыФормы.Вставить("ВидИнформационнойБазы",фКэшЗначений.ТекущаяИнформационнаяБаза);
	ПараметрыФормы.Вставить("Режим"            ,Режим);
	ПараметрыФормы.Вставить("ВыводитьВложенные",Истина);
	
	Если НЕ ПустаяСтрока(ТекущаяСтрока[ИмяПоля]) Тогда
		
		ПараметрыФормы.Вставить("ТекПутьКДанным",ТекущаяСтрока[ИмяПоля]);
		
	КонецЕсли; 
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьФормуПолейПостроителяОкончание", ЭтотОбъект, ДополнительныеПараметры); 
	ОткрытьФорму("ОбщаяФорма.бит_мпд_ФормаВыбораСвойствПостроителя",ПараметрыФормы,,,,,Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры // ОткрытьФормуПолейПостроителя()

// Процедура окончание процедуры "ОткрытьФормуПолейПостроителя".
// 
&НаКлиенте 
Процедура ОткрытьФормуПолейПостроителяОкончание(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	ИмяТабЧасти 	= ДополнительныеПараметры.ИмяТабЧасти;
	ИмяПоля			= ДополнительныеПараметры.ИмяПоля;
	ТекущаяСтрока 	= Элементы[ИмяТабЧасти].ТекущиеДанные;
	
	Если ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
	
		ТекущаяСтрока[ИмяПоля] = РезультатВыбора.ПутьКДанным;
		
		Если ИмяТабЧасти = "ТаблицаОтбор" Тогда
		
			ТекущаяСтрока.ТипЗначения  = РезультатВыбора.ТипЗначения;
			ТекущаяСтрока.Значение     = ТекущаяСтрока.ТипЗначения.ПривестиЗначение(ТекущаяСтрока.Значение);
			ТекущаяСтрока.ВидСравнения = ВидСравнения.Равно;
			
			Если ТекущаяСтрока.ПутьКДанным = "Периодичность" 
				 И ТипЗнч(ТекущаяСтрока.Значение) = Тип("Число") Тогда
			
				ТекущаяСтрока.ЭтоПериодичность = Истина;
			
			КонецЕсли; 
			
		ИначеЕсли ИмяТабЧасти = "Поля" Тогда	
			
			Если РезультатВыбора.ЭтоЧисловоеПоле Тогда
				
				ТекущаяСтрока.ВидПоля = "Ресурс";
			
			Иначе	
				
				ТекущаяСтрока.ВидПоля = "Поле";
				
			КонецЕсли; 
			
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры // ОткрытьФормуПолейПостроителяОкончание()

#КонецОбласти

