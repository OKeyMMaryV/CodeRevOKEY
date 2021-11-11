﻿#Область ОписаниеПеременных

// Хранит соответствие результатов формирования отчета.
&НаКлиенте
Перем мСоответствиеРезультатов;

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриОткрытии" формы.
// 
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	мСоответствиеРезультатов = Новый Соответствие;
	 	
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события "ОбработкаОповещения" формы.
// 
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Оповещение из хранилища настроек при сохранении.
	Если ИмяСобытия = ("СохраненаНастройка_" + фПолноеИмяОтчета) Тогда
		
		ОбновитьПанельСохраненныхНастроек(Истина, Параметр);
		
	// Оповещение из формы настрек при закрытии
	ИначеЕсли ИмяСобытия = ("ИзмененыНастройки_" + фПолноеИмяОтчета) Тогда
		
		СтруктураПараметров = Параметр;
		
		Отчет.НастройкаПериода		 = СтруктураПараметров.НастройкаПериода;
		
		Для каждого ЭлМассива Из фСписокПараметровНаФорме Цикл
			ИмяПараметра = ЭлМассива.Значение;
			Отчет[ИмяПараметра] = СтруктураПараметров[ИмяПараметра];
		КонецЦикла;
		ЗагрузитьНастройкиИзСтруктуры(СтруктураПараметров);
						
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
// 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Отчет);
	
	фПолноеИмяОтчета = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтаФорма.ИмяФормы, Истина);
	
	// Вызов механизма защиты
	
	
	фЗагружатьНастройки   = Истина;
	
	РежимФормирования = бит_ОтчетыСервер.РежимФормированияОтчетов(фПолноеИмяОтчета);
	
	УправлениеВидимостьюДоступностью();
	
	ОбновитьПанельСохраненныхНастроек();
	
	ЗаполнитьДополнительныеСписки();
	
	бит_ОтчетыСервер.УстановитьВидимостьПанелиНастроекПоУмолчаниюТакси(Элементы.ФормаКомандаПанельНастроек
														, Элементы.ГруппаПанельНастроек
														, фСкрытьПанельНастроек
														, фТаксиОткрытьПанельНастроек);
														
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события "ПриЗагрузкеДанныхИзНастроекНаСервере" формы.
// 
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Видимость панели настроек
	бит_ОтчетыСервер.УстановитьВидимостьПанелиНастроек(Элементы.ФормаКомандаПанельНастроек
														, Элементы.ГруппаПанельНастроек
														, фСкрытьПанельНастроек
														, фТаксиОткрытьПанельНастроек);
	
	// Видимость панели сохраненных настроек
	Элементы.ФормаКомандаПанельСохраненныхНастроек.Пометка 	 = Не фСкрытьПанельСохраненныхНастроек;
	Элементы.ГруппаПанельВыбораСохраненныхНастроек.Видимость = Не фСкрытьПанельСохраненныхНастроек;
	
	// Фильтр сохраненных настроек по варианту
	Элементы.КомандаФильтроватьНастройкиПоВариантам.Пометка = фФильтроватьНастройкиПоВарианту;
	ИзменитьФильтрНастроек(фФильтроватьНастройкиПоВарианту);
	
	УправлениеВидимостьюДоступностью();
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

// Процедура - обработчик события "ПриСохраненииВариантаНаСервере" формы.
// 
&НаСервере
Процедура ПриСохраненииВариантаНаСервере(Настройки)
	
	Если фКлючТекущегоВарианта <> КлючТекущегоВарианта Тогда
		УстановитьТекущийВариант(КлючТекущегоВарианта); 		
	КонецЕсли;                                       
		
КонецПроцедуры // ПриСохраненииВариантаНаСервере()

// Процедура - обработчик события "ПриЗагрузкеВариантаНаСервере" формы.
// 
&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	фКлючТекущегоВарианта = КлючТекущегоВарианта;
		
	КлючОбъекта = ?(ЗначениеЗаполнено(КлючТекущегоВарианта), 
					фПолноеИмяОтчета + "/" + КлючТекущегоВарианта, 
					фПолноеИмяОтчета);
		
	бит_ОтчетыСервер.ИзменитьВидимостьСохраненныхНастроек(Элементы, фСтруктураСохраненныхНастроек, КлючОбъекта, фФильтроватьНастройкиПоВарианту, Истина);
	
	Если фЗагружатьНастройки Тогда
		
		// Установка настройки, используемой при открытии, если такая указана в справочнике.
		КлючНастройкиПоУмолчанию = бит_ОтчетыСервер.НайтиНастройкуПоУмолчаниюДляОбъекта(КлючОбъекта, Истина);
		
		Если ЗначениеЗаполнено(КлючНастройкиПоУмолчанию) Тогда
			УстановитьТекущиеПользовательскиеНастройки(КлючНастройкиПоУмолчанию);
		Иначе
			УстановитьСтандартныеНастройкиСервер(Истина);
			фИмяЭлемента_ВыбраннаяНастройка = "";
		КонецЕсли;
		
		Результат.Очистить();
	
	КонецЕсли;
			
КонецПроцедуры // ПриЗагрузкеВариантаНаСервере()

// Процедура - обработчик события "ПриСохраненииПользовательскихНастроекНаСервере" формы.
// 
&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
		
	Для каждого ЭлементСписка Из фСписокПараметровНаФорме Цикл
		
		ИмяПараметра = ЭлементСписка.Значение;
		бит_ОтчетыСервер.УстановитьЗначениеПараметраКомпоновщика(Отчет.КомпоновщикНастроек, 
																 Отчет[ИмяПараметра], 
																 ИмяПараметра);
		
	КонецЦикла; 
	
КонецПроцедуры // ПриСохраненииПользовательскихНастроекНаСервере()
 
// Процедура - обработчик события "ПриЗагрузкеПользовательскихНастроекНаСервере" формы.
// 
&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если Настройки = Неопределено ИЛИ Не фЗагружатьНастройки Тогда 
		Возврат;
	КонецЕсли;
	          	
	бит_ОтчетыСервер.ЗаполнитьПараметрыНаФормеИзНастроек(Отчет, Настройки, фСписокПараметровНаФорме);
                                      		
	Если Настройки.ДополнительныеСвойства.Свойство("КлючНастройки") Тогда
		ТекКлючНастройки = Настройки.ДополнительныеСвойства.КлючНастройки;
		бит_ОтчетыСервер.ВыделитьТекущуюСохраненнуюНастройку(Элементы, 
															фСтруктураСохраненныхНастроек, 
															фИмяЭлемента_ВыбраннаяНастройка,
															фФильтроватьНастройкиПоВарианту,
															ТекКлючНастройки);
	КонецЕсли;
		
КонецПроцедуры // ПриЗагрузкеПользовательскихНастроекНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "Нажатие" элемента формы "ДекорацияНастройки<№>".
// 
&НаКлиенте
Процедура Подключаемый_ДекорацияСохраненнойНастройкиНажатие(Элемент)
	
	// Сохраним результат
	Если ЗначениеЗаполнено(фИмяЭлемента_ВыбраннаяНастройка) 
		И фСтруктураСохраненныхНастроек.Свойство(фИмяЭлемента_ВыбраннаяНастройка) Тогда
		СтруктураСохр = Новый Структура("Результат, ДанныеРасшифровки", Результат, ДанныеРасшифровки);
		КлючНастройки = фСтруктураСохраненныхНастроек[фИмяЭлемента_ВыбраннаяНастройка].КлючНастройки;
		мСоответствиеРезультатов.Вставить(КлючНастройки, СтруктураСохр);
	КонецЕсли;
	
	// Обновление пользовательских настроек
	ИмяЭлемента = Элемент.Имя;
	НастройкиОбновлены = ОбновитьНастройки(ИмяЭлемента, мСоответствиеРезультатов);
	Если Не НастройкиОбновлены Тогда
		ТекстСообщения = Нстр("ru = 'Настройка не найдена. Обновите панель сохраненных настроек.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения); 	
	КонецЕсли;
	
	бит_ОтчетыКлиент.ОбработатьНажатиеНаПолеСохраненнойНастройки(Элементы, 
																Элемент, 
																фИмяЭлемента_ВыбраннаяНастройка);
																	     			
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "ПериодДатаНачала".
// 
&НаКлиенте
Процедура ПериодДатаНачалаПриИзменении(Элемент)
	
	ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.Период.ДатаНачала, 
																				Отчет.Период.ДатаОкончания);
		
КонецПроцедуры // ПериодДатаНачалаПриИзменении()

// Процедура - обработчик события "ПриИзменении" поля ввода "ПериодДатаОкончания".
// 
&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(Отчет.Период.ДатаНачала, 
																				 Отчет.Период.ДатаОкончания);
		
КонецПроцедуры // ПериодДатаОкончанияПриИзменении()

// Процедура - обработчик события "ПриАктивизацииОбласти" поля табличного документа "Результат".
// 
&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	СуммаОтчета = бит_ОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(Результат);
	
КонецПроцедуры // РезультатПриАктивизацииОбласти()

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - действие команды "Сформировать".
// Выполняется формирование отчета.
// 
&НаКлиенте
Процедура КомандаСформировать(Команда)
	
	бит_ОтчетыКлиент.СформироватьОтчет(ЭтаФорма, Элементы.ГруппаКоманднаяПанельОтчетаЛевая, РежимФормирования);
	
КонецПроцедуры

// Процедура - обработчик команды "КомандаФильтроватьНастройкиПоВариантам".
// 
&НаКлиенте
Процедура КомандаФильтроватьНастройкиПоВариантам(Команда)
	
	фФильтроватьНастройкиПоВарианту = Не фФильтроватьНастройкиПоВарианту;
	
	Элементы.КомандаФильтроватьНастройкиПоВариантам.Пометка = фФильтроватьНастройкиПоВарианту;
	ИзменитьФильтрНастроек(фФильтроватьНастройкиПоВарианту);
	
КонецПроцедуры // КомандаФильтроватьНастройкиПоВариантам()

// Процедура - обработчик команды "КомандаПанельНастроек".
// 
&НаКлиенте
Процедура КомандаПанельНастроек(Команда)
	
	ОбработкаКомандыПанелиНастроекСервер();	
	
КонецПроцедуры // КомандаПанельНастроек()

// Процедура - обработчик команды "КомандаПанельСохраненныхНастроек".
// 
&НаКлиенте
Процедура КомандаПанельСохраненныхНастроек(Команда)
	
	фСкрытьПанельСохраненныхНастроек = Не фСкрытьПанельСохраненныхНастроек;
	
	Элементы.ФормаКомандаПанельСохраненныхНастроек.Пометка   = Не фСкрытьПанельСохраненныхНастроек;
	Элементы.ГруппаПанельВыбораСохраненныхНастроек.Видимость = Не фСкрытьПанельСохраненныхНастроек;
	
КонецПроцедуры // КомандаПанельСохраненныхНастроек()

// Процедура - обработчик команды "КомандаПанельСохраненныхНастроек".
// 
&НаКлиенте
Процедура КомандаОбновитьПанельСохраненныхНастроек(Команда)
	
	ОбновитьПанельСохраненныхНастроек(Истина);	
	
КонецПроцедуры // КомандаОбновитьПанельСохраненныхНастроек()

// Процедура - обработчик команды "КомандаВыбратьПериодчерезФорму".
// 
&НаКлиенте
Процедура КомандаНастроитьПериод(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОткрытьДиалогСтандартногоПериода(Отчет);
	
КонецПроцедуры // КомандаНастроитьПериод()

// Процедура - обработчик команды "КомандаУстановитьСтандартныеНастройки".
// 
&НаКлиенте
Процедура КомандаУстановитьСтандартныеНастройки(Команда)
	
	УстановитьСтандартныеНастройкиСервер();
	
КонецПроцедуры // КомандаУстановитьСтандартныеНастройки()
     
// Процедура - обработчик команды "Результат_ПоказатьВОтдельномОкне".
// 
&НаКлиенте
Процедура Результат_ПоказатьВОтдельномОкне(Команда)
	
	бит_ОтчетыКлиент.ПоказатьКопиюРезультата(Результат);	
		
КонецПроцедуры // Результат_ПоказатьВОтдельномОкне()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет дополнительные списки.
// 
// Параметры:
//  Нет
// 
&НаСервере
Процедура ЗаполнитьДополнительныеСписки()

	// Список имен параметров СКД, заполняемых пользователем через элементы формы.
	ИмяОтчета = бит_ОбщегоНазначения.ПолучитьИмяОбъектаПоИмениФормы(ЭтаФорма.ИмяФормы, Ложь); 
	Отчеты[ИмяОтчета].ЗаполнитьДополнительныеСписки(фСписокПараметровНаФорме);
	
КонецПроцедуры // ЗаполнитьДополнительныеСписки()

// Процедура управляет видимостью и доступностью элементов формы.
// 
// Параметры:
//  Нет
// 
&НаСервере
Процедура УправлениеВидимостьюДоступностью()
	
	// Установка видимости и доступности элементов формы в зависимости от типа отчета 
	// - обычный или расшифровка. 
	бит_ОтчетыСервер.УстановитьВидимостьДоступностьЭлементов(Элементы, 
															Параметры.КлючВарианта, 
															Параметры.ПредставлениеВарианта);
		          	
КонецПроцедуры // УправлениеВидимостьюДоступностью()

// Процедура - обработчик команды "КомандаПанельНастроек".
// 
// Параметры: 
//  СкрытьПанельПриФормировании - Булево (По умолчанию = Ложь).
//
&НаСервере
Процедура ОбработкаКомандыПанелиНастроекСервер(СкрытьПанельПриФормировании = Ложь)
	
	// Видимость панели настроек
	бит_ОтчетыСервер.ОбработкаКомандыПанелиНастроек(Элементы.ФормаКомандаПанельНастроек
													 , Элементы.ГруппаПанельНастроек
													 , фСкрытьПанельНастроек
													 , фТаксиОткрытьПанельНастроек
													 , СкрытьПанельПриФормировании);
	
КонецПроцедуры // ОбработкаКомандыПанелиНастроекСервер()

// Процедура включает/отключает фильтр настроек по варианту.
// 
// Параметры:
//  Фильтровать  - Булево.
// 
&НаСервере
Процедура ИзменитьФильтрНастроек(Фильтровать)

	КлючОбъекта = ?(ЗначениеЗаполнено(КлючТекущегоВарианта), 
					фПолноеИмяОтчета + "/" + КлючТекущегоВарианта, 
					фПолноеИмяОтчета);
	бит_ОтчетыСервер.ИзменитьВидимостьСохраненныхНастроек(Элементы, фСтруктураСохраненныхНастроек, КлючОбъекта, фФильтроватьНастройкиПоВарианту);	

КонецПроцедуры // ИзменитьФильтрНастроек()

// Функция обновляет настройки отчета.
// 
// Параметры:
//  ИмяЭлемента  		 	- Строка.
//  СоответствиеРезультатов - Соответствие.
// 
// ВозращаемоеЗначение:
//  Булево - настройки обновлены.
// 
&НаСервере
Функция ОбновитьНастройки(ИмяЭлемента, СоответствиеРезультатов)

	НастройкиОбновлены = Ложь;
	
	Результат.Очистить();
	
	СтруктураНастроек = фСтруктураСохраненныхНастроек[ИмяЭлемента];
	
	Настройки = бит_ОтчетыСервер.ПолучитьНастройкиОтчета(СтруктураНастроек);
	
	Если Настройки <> Неопределено Тогда
			
		КлючНастройки = СтруктураНастроек.КлючНастройки;    	
		КлючОбъекта = СтрЗаменить(СтруктураНастроек.КлючОбъекта, фПолноеИмяОтчета + "/", "");
		
		Если КлючОбъекта <> КлючТекущегоВарианта Тогда
			фЗагружатьНастройки = Ложь;	
			УстановитьТекущийВариант(КлючОбъекта);
			фЗагружатьНастройки = Истина;
		КонецЕсли;
		
		УстановитьТекущиеПользовательскиеНастройки(КлючНастройки);
		НастройкиОбновлены = Истина;
		
	КонецЕсли;
	
	// Выведем результат, если он уже формировался для текущей настройки.
	Если НастройкиОбновлены Тогда		
		СтруктураРез = СоответствиеРезультатов.Получить(КлючНастройки);
		Если СтруктураРез <> Неопределено Тогда
			Результат.Вывести(СтруктураРез.Результат);
			ДанныеРасшифровки = СтруктураРез.ДанныеРасшифровки;
		КонецЕсли; 		
	КонецЕсли;
	       	
	Возврат НастройкиОбновлены;

КонецФункции // ОбновитьНастройки()

// Процедура обновляет панель сохраненных настроек.
// 
// Параметры:
//  Очищать  - Булево (Необязательный, по умолчанию = Ложь).
//  ТекКлючНастройки  (Необязательный).
// 
&НаСервере
Процедура ОбновитьПанельСохраненныхНастроек(Очищать = Ложь, ТекКлючНастройки = Неопределено)

	ГруппаПанели = Элементы.ГруппаПанельВыбораСохраненныхНастроек;
	
	СтруктураДоступности = бит_ОтчетыСервер.ПроверитьДоступностьВариантовНастроек(фПолноеИмяОтчета, Истина);
	лИспользуемыйПриОткрытииВариант = СтруктураДоступности.ИспользуемыйПриОткрытииВариант;
		
	Если Очищать Тогда 	
		
		бит_РаботаСДиалогамиСервер.УдалитьЭлементыГруппыФормы(Элементы, ГруппаПанели); 			
		
	Иначе
		
		Если лИспользуемыйПриОткрытииВариант = Неопределено Тогда
			КлючТекущегоВарианта = "";
			Возврат;
		Иначе
			КлючТекущегоВарианта = лИспользуемыйПриОткрытииВариант;		
		КонецЕсли;
	
	КонецЕсли; 	
	
	КлючОбъекта = фПолноеИмяОтчета + "/" + КлючТекущегоВарианта;
				
	бит_ОтчетыСервер.ОбновитьПанельСохраненныхНастроек(Элементы, 
													ГруппаПанели, 
													КлючОбъекта, 
													фСтруктураСохраненныхНастроек,
													СтруктураДоступности,
													фФильтроватьНастройкиПоВарианту,
													фИмяЭлемента_ВыбраннаяНастройка);
	
	Если ТекКлючНастройки <> Неопределено Тогда
		бит_ОтчетыСервер.ВыделитьТекущуюСохраненнуюНастройку(Элементы, 
															фСтруктураСохраненныхНастроек, 
															фИмяЭлемента_ВыбраннаяНастройка,
															фФильтроватьНастройкиПоВарианту,
															ТекКлючНастройки);	
	Иначе
		фИмяЭлемента_ВыбраннаяНастройка = "";														
	КонецЕсли;
	
КонецПроцедуры // ОбновитьПанельСохраненныхНастроек()

// Процедура устанавливает стандартные настройки варианта 
// и обновляет по ним элементы формы.
// Заменяет типовую команду "СтандартныеНастройки".
// 
&НаСервере
Процедура УстановитьСтандартныеНастройкиСервер(ВосстанавливатьНастройки = Ложь)
	
	бит_ОтчетыСервер.УстановитьСтандартныеНастройкиСервер(Отчет, ВосстанавливатьНастройки, фСписокПараметровНаФорме);
	
	бит_ОтчетыСервер.ВыделитьТекущуюСохраненнуюНастройку(Элементы, 
														фСтруктураСохраненныхНастроек, 
														фИмяЭлемента_ВыбраннаяНастройка,
														фФильтроватьНастройкиПоВарианту);
															
КонецПроцедуры // УстановитьСтандартныеНастройкиСервер()          

// Процедура загружает пользовательские настройки компоновщика.
// 
// Параметры:
//  СтруктураПараметров  - Структура.
// 
&НаСервере
Процедура ЗагрузитьНастройкиИзСтруктуры(СтруктураПараметров)

	Отчет.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(СтруктураПараметров.ПользовательскиеНастройки);
		
КонецПроцедуры // ЗагрузитьНастройкиИзСтруктуры()

#КонецОбласти

