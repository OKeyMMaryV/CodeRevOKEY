﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНЧАЕНИЯ

// бит_ASubbotina Процедура формирует структуру подбора
//
// Параметры:
//  СтрокаСДанными - СтрокаТаблицыЗначений.Заявки.
//
&НаКлиенте
Функция СформироватьСтруктуруПодбора(СтрокаСДанными)
	
	СтруктураПодбора = Новый Структура();
		
	СтруктураПодбора.Вставить("ОсновноеСредство"		 , СтрокаСДанными.ВНА);
	СтруктураПодбора.Вставить("Контрагент"				 , СтрокаСДанными.Контрагент);
	СтруктураПодбора.Вставить("ДоговорКонтрагента"		 , СтрокаСДанными.ДоговорКонтрагента);
	СтруктураПодбора.Вставить("Сумма"					 , СтрокаСДанными.Сумма);
		
	Возврат СтруктураПодбора;
	
КонецФункции // СформироватьСтруктуруПодбора()

// бит_ASubbotina Процедура оповещает форму - владельца о выборе
//
// Параметры:
//  Параметр  - Структура или Массив
//
&НаКлиенте
Процедура ОповеститьВладельцаОВыборе(Команда, МассивПодбора)

	Оповестить(Команда, МассивПодбора);	

КонецПроцедуры // ОповеститьВладельцаОВыборе()

// бит_ASubbotina Процедура формирует массив данных для переноса
//
// Параметры:
//  Команда  - Строка
//
&НаКлиенте
Процедура ПеренестиДанные(Команда)
	
	ДанныеДляПодбора = Объект.ПереченьОбъектов.НайтиСтроки(Новый Структура("Выполнять", Истина));
	
	// Получаем количество заявок для переноса.
	Кол_во = ДанныеДляПодбора.Количество();
	
	Если Кол_во <> 0 Тогда
		
		Счетчик = 0;
		
		МассивПодбора = Новый Массив;
	
		Для Каждого ТекСтрока Из ДанныеДляПодбора Цикл
			
			Счетчик = Счетчик + 1;
			
			// Сформируем структуру подбора и оповестим о выборе тек. заявки.
			СтруктураПодбора = СформироватьСтруктуруПодбора(ТекСтрока);
			МассивПодбора.Добавить(СтруктураПодбора);
			
			Состояние("Обработано ВНА: " + Счетчик + " из " + Кол_во);
			
		КонецЦикла;
		
		ОповеститьВладельцаОВыборе(Команда, МассивПодбора);
		
	КонецЕсли;

КонецПроцедуры // ПеренестиДанные()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// бит_ASubbotina Процедура - обработчик события "Нажатие" кнопки "ПеренестиДобавить" 
// коммандной панели "ПереченьОбъектовКоманднаяПанель".
//
&НаКлиенте
Процедура ПеренестиДобавить(Команда)
	
	ПеренестиДанные("Добавить");
	
КонецПроцедуры // ПеренестиДобавить()

// бит_ASubbotina Процедура - обработчик события "Нажатие" кнопки "ПеренестиЗагрузить" 
// коммандной панели "ПереченьОбъектовКоманднаяПанель".
//
&НаКлиенте
Процедура ПеренестиЗагрузить(Команда)
	
	ПеренестиДанные("Загрузить");
	
КонецПроцедуры // ПеренестиЗагрузить()

// бит_ASubbotina Процедура - обработчик события "Нажатие" кнопки "ОбновитьПеречень" 
// коммандной панели "ПереченьОбъектовКоманднаяПанель".
//
&НаКлиенте
Процедура ОбновитьПеречень(Команда)
	
	Обновить();
	
КонецПроцедуры // ОбновитьПеречень()

// бит_ASubbotina Процедура - обработчик события "Нажатие" кнопки "ПереченьСнятьФлажки" 
// коммандной панели "ПереченьОбъектовКоманднаяПанель".
//
&НаКлиенте
Процедура ПереченьСнятьФлажки(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.ПереченьОбъектов, "Выполнять", 0);

КонецПроцедуры // ПереченьСнятьФлажки()

// бит_ASubbotina Процедура - обработчик события "Нажатие" кнопки "ПереченьУстановитьФлажки" 
// коммандной панели "ПереченьОбъектовКоманднаяПанель".
//
&НаКлиенте
Процедура ПереченьУстановитьФлажки(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.ПереченьОбъектов, "Выполнять", 1);
	
КонецПроцедуры // ПереченьУстановитьФлажки()

// бит_ASubbotina Процедура - обработчик события "Нажатие" кнопки "ПереченьИнвертироватьФлажки" 
// коммандной панели "ПереченьОбъектовКоманднаяПанель".
//
&НаКлиенте
Процедура ПереченьИнвертироватьФлажки(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.ПереченьОбъектов, "Выполнять", 2);
	
КонецПроцедуры // ПереченьИнвертироватьФлажки()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ НА СЕРВЕРЕ
  
// бит_ASubbotina Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// стандартные действия при создании на сервере
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	МетаданныеОбъекта = Метаданные.Обработки.бит_му_ПодборВНА;
	
	Команда = Параметры.Команда;
	
	Если Команда = "" Тогда
		бит_ОбщегоНазначенияКлиентСервер.СообщитьОбОтказеОткрытияОбработкиСамостоятельно(МетаданныеОбъекта.Синоним, Отказ);
		Возврат;
	КонецЕсли;
	
	
	Объект.Организация = Параметры.Организация;
	
	ЗакрыватьПриВыборе = Ложь;

	// Заполним значения периода
	Если Команда = "НачислениеПроцентов" Тогда
		Период.ДатаНачала    = ?(Параметры.Свойство("ДатаНачала")	, Параметры.ДатаНачала	 , НачалоДня(ТекущаяДата()));
		Период.ДатаОкончания = ?(Параметры.Свойство("ДатаОкончания"), Параметры.ДатаОкончания, КонецДня(ТекущаяДата()));
	Иначе
		Период.ДатаНачала    = ?(Параметры.Свойство("Дата")	, Параметры.Дата, НачалоДня(ТекущаяДата()));	 
	КонецЕсли;
	
	ИнинциализироватьСКД(Команда);
	
	Обновить(); 
	
	Если Параметры.Свойство("Заголовок") Тогда
		ЭтаФорма.Заголовок = Параметры.Заголовок;
	КонецЕсли;

	УстановитьВидимость();
	
КонецПроцедуры // ПриСозданииНаСервере()


////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ СЕРВЕРНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// бит_ASubbotina Процедура устанавливает видимость элементов формы
//
// Параметры:
//  Нет	
//
&НаСервере
Процедура УстановитьВидимость()

	Перечень = Элементы.ПереченьОбъектов.ПодчиненныеЭлементы;
	
	//Если Команда = "НачислениеПроцентов" ИЛИ Команда = "РеклассификацияЗадолженности" Тогда
	//	ЭтоНачислениеИлиРекласс = Истина;
	//Иначе
	//	ЭтоНачислениеИлиРекласс = Ложь;
	//КонецЕсли;
	ЭтоНачПроц = Команда = "НачислениеПроцентов";
	ЭтоРекласс = Команда = "РеклассификацияЗадолженности";
	
	Элементы.СтраницаНачислениеПроцентов.Видимость = ЭтоНачПроц;
	Элементы.СтраницаРеклассификация.Видимость = ЭтоРекласс;
	//Элементы.Организация.Видимость = ЭтоНачислениеИлиРекласс;
	//
	//Перечень.ПереченьОбъектовВидКласса.Видимость					= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовИнвентарныйНомер.Видимость				= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовОрганизация.Видимость					= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовДатаПринятияКУчету.Видимость 			= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовДокументБУ.Видимость 					= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовМестонахождение.Видимость 				= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовМетодНачисленияАмортизации.Видимость 	= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовМодельУчета.Видимость 					= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовМОЛ.Видимость 							= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовНачислятьАмортизацию.Видимость 		= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовПервоначальнаяСтоимость.Видимость 		= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовСубконтоДт1.Видимость 					= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовСубконтоДт2.Видимость 					= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовСубконтоДт3.Видимость					= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовСубконтоКт1.Видимость 					= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовСубконтоКт2.Видимость 					= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовСубконтоКт3.Видимость 					= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовСчетДт.Видимость 						= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовСчетКт.Видимость						= Не ЭтоНачислениеИлиРекласс;
	//Перечень.ПереченьОбъектовСуммаНДС.Видимость 					= Не ЭтоНачислениеИлиРекласс;
	// 	
	//	
	Элементы.ПериодДатаОкончания.Видимость = Не ЭтоРекласс;
	//Перечень.ПереченьОбъектовВНА.Видимость = Не ЭтоРекласс;
	
КонецПроцедуры // УстановитьВидимость()

// бит_ASubbotina Процедура ОПИСАНИЕ
//
// Параметры:
//  Параметр1  - Тип_описание
//  Параметр2  - Тип_описание
//
&НаСервере
Процедура Обновить()

	Запрос    = ПолучитьЗапросСКД();
	Результат = Запрос.Выполнить();
	 
	Если Результат.Пустой() Тогда
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение("Нет данных, удовлетворяющих отбору.");
	КонецЕсли; 
	 
	Объект.ПереченьОбъектов.Очистить();
	 
	Выборка = Результат.Выбрать();
	 
	Пока Выборка.Следующий() Цикл
	 
	   	НоваяСтрока = Объект.ПереченьОбъектов.Добавить();
	   	ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		  
  	КонецЦикла;

КонецПроцедуры // Обновить()

// бит_ASubbotina Функция получает запрос схемы компановки данных для перечня документов на оплату
//
// Параметры:
//  АдресСКД      - Строка
//  Компоновщик   - КомпоновщикНастроекКомпоновкиДанных
//  ПериодРасхода - СтандартныйПериод
//
// Возращаемое значение:
//  Запрос
//
&НаСервере
Функция ПолучитьЗапросСКД() Экспорт
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);

	//Выполняем компановку макета МакетСКД
	// (настройки берутся из схемы компановки данных и из пользовательских настроек)
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетСКД = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных, Объект.Компоновщик.ПолучитьНастройки());
	
	//Заполняем параметры макета компановки данных
	МакетСКД.ЗначенияПараметров.Организация.Значение   = Объект.Организация;
	Если Команда = "НачислениеПроцентов" Тогда
 		МакетСКД.ЗначенияПараметров.ДатаНачала.Значение    = Период.ДатаНачала;
		МакетСКД.ЗначенияПараметров.ДатаОкончания.Значение = Период.ДатаОкончания;
	ИначеЕсли Команда = "РеклассификацияЗадолженности" Тогда
		МакетСКД.ЗначенияПараметров.Дата.Значение    	  = Период.ДатаНачала;
		МакетСКД.ЗначенияПараметров.ДатаЧерезГод.Значение = ДобавитьМесяц(Период.ДатаНачала, 12);
	КонецЕсли;
	
	//Получаем запрос макета компановки данных
	Запрос = Новый Запрос(МакетСКД.НаборыДанных.НаборДанных.Запрос);
	
	//Устанавливаем параметры запроса
	ОписаниеПараметровЗапроса = Запрос.НайтиПараметры();
	Для каждого ОписаниеПараметраЗапроса из ОписаниеПараметровЗапроса Цикл
		Запрос.УстановитьПараметр(ОписаниеПараметраЗапроса.Имя, МакетСКД.ЗначенияПараметров[ОписаниеПараметраЗапроса.Имя].Значение);
	КонецЦикла;
	
	Возврат Запрос;
	
КонецФункции // ПолучитьЗапросСКД()

// бит_ASubbotina Процедура инициализирует схему компановки данных
//
// Параметры:
//  Команда  - Строка
//
&НаСервере
Процедура ИнинциализироватьСКД(Команда)

	//Инициализация схемы компановки данных
	Если Команда = "НачислениеПроцентов" Тогда
		СхемаКомпоновкиДанных = Обработки.бит_му_ПодборВНА.ПолучитьМакет("СКДНачислениеФинансовыхПроцентов");
	ИначеЕсли Команда = "РеклассификацияЗадолженности" Тогда
	    СхемаКомпоновкиДанных = Обработки.бит_му_ПодборВНА.ПолучитьМакет("СКДРеклассификацияЗадолженности");
	КонецЕсли;
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	
	Объект.Компоновщик.Инициализировать(ИсточникНастроек);
	Объект.Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);

КонецПроцедуры // ИнинциализироватьСКД() 
