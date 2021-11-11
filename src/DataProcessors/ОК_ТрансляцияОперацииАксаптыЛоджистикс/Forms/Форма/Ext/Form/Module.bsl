﻿
&НаКлиенте
Процедура КнопкаВыполнитьНажатие(Команда)
	РучнаяТрансляцияЗагруженныхДанныхИзАксапты_Вызов_Функции();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	//++ СВВ
	ГруппаНастроек	= "РегламентнаяТрансляцияОперацийАксапты";
	ЭлементОтбора = бит_ок_НастройкиМеханизмаИмпортаДанных.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Группа");
	ЭлементОтбора.ПравоеЗначение = ГруппаНастроек;
	//НастройкиМеханизмаИмпортаДанных.Отбор.Группа.Значение 		= ГруппаНастроек;
	//НастройкиМеханизмаИмпортаДанных.Отбор.Группа.Использование	= Истина;
	//-- СВВ
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеДействияФормыРастранслировать(Команда)
	Ответ = Вопрос("Будет выполнена отмена трансляции движений для документов. Продолжить?", 
	РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да, "Отмена трансляции движений");
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;

	АдресФормы = "";
	КолВоДокументов = 0;
	РучнаяРасТрансляцияЗагруженныхДанныхИзАксапты_Вызов_Функции(АдресФормы, КолВоДокументов);
	
	//++ СВВ {[+](фрагмент добавлен), Сапожников Вадим 22.10.2015 11:20:40
	ОбработкаДокументовРеТрансляция(АдресФормы, КолВоДокументов);
	//-- СВВ}
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанель2Обновить(Команда)
	ЗаполнитьНастройки_Вызов_Функции();
КонецПроцедуры

&НаСервере
Функция РучнаяТрансляцияЗагруженныхДанныхИзАксапты_Вызов_Функции()
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.РучнаяТрансляцияЗагруженныхДанныхИзАксапты();
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаСервере
Функция РучнаяРасТрансляцияЗагруженныхДанныхИзАксапты_Вызов_Функции(АдресФормы,КолВоДокументов)
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.РучнаяРасТрансляцияЗагруженныхДанныхИзАксапты(УникальныйИдентификатор, АдресФормы, КолВоДокументов);
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаСервере
Функция ЗаполнитьНастройки_Вызов_Функции()
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.ЗаполнитьНастройки();
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

//++ СВВ {[+](фрагмент добавлен), Сапожников Вадим 22.10.2015 11:42:43
&НаКлиенте
Процедура ОбработкаДокументовРеТрансляция(АдресФормы, КолВоДокументов)
	
	МассивОчередей	= СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Объект.Очередность, ";");
	
	Для Каждого ТекущаяОчередь из МассивОчередей Цикл 
		Если ОК_ОбщегоНазначения.ПроверитьСтрокаВЧисло(ТекущаяОчередь) Тогда 
			Очередность_	= Число(ТекущаяОчередь);
		Иначе 
			Сообщение	= "Очередь " + ТекущаяОчередь + " не удается привести к числу, она исключается из трансляции";
			ОК_ОбщегоНазначения.ВыводСтатусаСообщения(,Сообщение);
			СделатьЗаписьЖР(Сообщение);
			Продолжить;
		КонецЕсли;
		
		АдресПриемников = ПолучитьПриемники(Очередность_);
		Если АдресПриемников = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		
		Сообщение	= "Начало отмены трансляции";
		бит_ОбщегоНазначения.бит_Сообщить(Сообщение, СтатусСообщения.Внимание);
		СделатьЗаписьЖР(Сообщение);	
		Порция = ?(Цел(КолВоДокументов / 100) < 1, 1, Цел(КолВоДокументов / 100));
		Сч = 1;
		Состояние("Обработано по очередности " + ТекущаяОчередь, Окр(Сч / КолВоДокументов * 100,2,1), "всего документов " + КолВоДокументов);
		Сч =ОтменаТрансляцииСПрогрессБаром(АдресПриемников, АдресФормы, КолВоДокументов, Порция, Сч);
		Пока Сч <> Неопределено Цикл
			ОбработкаПрерыванияПользователя();
			Состояние("Обработано по очередности " + ТекущаяОчередь, Окр(Сч / КолВоДокументов * 100,2,1), "всего документов " + КолВоДокументов);
			Сч = ОтменаТрансляцииСПрогрессБаром(АдресПриемников, АдресФормы, КолВоДокументов, Порция, Сч);
		КонецЦикла; 
		
	КонецЦикла;	
	
	Сообщение	= "Завершение отмены трансляции";
	СделатьЗаписьЖР(Сообщение);	
	
	Сообщить("Отмена трансляции движений завершена (" + ТекущаяДата() + "), обработано " + КолВоДокументов + ".", СтатусСообщения.Информация);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПриемники(Очередность)
	
	ЗапросПриемников = Новый Запрос;
	ЗапросПриемников.Текст = "ВЫБРАТЬ
	|	бит_НазначениеПравилТрансляцииСрезПоследних.ПравилоТрансляции.Приемник КАК ОбъектСистемы
	|ИЗ
	|	РегистрСведений.бит_НазначениеПравилТрансляции.СрезПоследних КАК бит_НазначениеПравилТрансляцииСрезПоследних
	|ГДЕ
	|	бит_НазначениеПравилТрансляцииСрезПоследних.ПравилоТрансляции.Очередность = &Очередность
	|
	|СГРУППИРОВАТЬ ПО
	|	бит_НазначениеПравилТрансляцииСрезПоследних.ПравилоТрансляции.Приемник";
	
	ЗапросПриемников.УстановитьПараметр("Очередность", Очередность); 
	Приемники 		= ЗапросПриемников.Выполнить().Выгрузить();
	
	МассивПриемники = ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(Приемники.ВыгрузитьКолонку("ОбъектСистемы"));
	КолВоПриемники  = МассивПриемники.Количество();
	
	Если КолВоПриемники = 0 Тогда
		Сообщение	= "Не указаны приемники для отмены трансляции движений!";
		бит_ОбщегоНазначения.бит_Сообщить(Сообщение, СтатусСообщения.Внимание);
		СделатьЗаписьЖР(Сообщение);
		Возврат Неопределено;
	КонецЕсли;
	Возврат ПоместитьВоВременноеХранилище(МассивПриемники, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Функция ОтменаТрансляцииСПрогрессБаром(АдресПриемников, АдресФормы, КолДокументов, Порция, НачалоСчетчика)
	
	МассивДокументов = ПолучитьИзВременногоХранилища(АдресФормы);
	МассивПриемники = ПолучитьИзВременногоХранилища(АдресПриемников);
	
	Счетчик = 0;
	Для Сч = НачалоСчетчика По КолДокументов Цикл
	//Для Каждого ТекДокумент Из МассивДокументов Цикл
		Если (Сч - НачалоСчетчика) = Порция Тогда
			Возврат Сч;
		КонецЕсли; 
		ТекДокумент = МассивДокументов[Сч-1];
		Счетчик = Счетчик + 1;
		Отказ   = Ложь;
		
		ДокументОбъект = ТекДокумент.ПолучитьОбъект();
		
		Если НЕ бит_ОбщегоНазначения.ЗаблокироватьОбъект(ДокументОбъект,Строка(ТекДокумент),,"Все") Тогда
			Продолжить;
		КонецЕсли; 
		
		Если бит_ОбщегоНазначения.ЕстьМеханизмКонтроляЗакрытогоПериода() Тогда
			
			// при наличиии механизма контроля закрытого периода сохраним движения для последующего анализа
			Выполнить("бит_КонтрольЗакрытогоПериода.КонсервироватьДвижения(ДокументОбъект,Отказ,РежимЗаписиДокумента.Проведение,РежимПроведенияДокумента.Неоперативный)");
			
		КонецЕсли; 		
		
		// Выполним отмену трансляции движений.
		ОтменитьТрансляцию(ДокументОбъект.Ссылка, МассивПриемники, Счетчик);
		
		Если бит_ОбщегоНазначения.ЕстьМеханизмКонтроляЗакрытогоПериода() Тогда
			
			// при наличиии механизма контроля закрытого периода сформируем корректирующие проводки			
			Выполнить("бит_КонтрольЗакрытогоПериода.КонтрольПриУдаленииПроведения(ДокументОбъект,Отказ)");
			
		КонецЕсли; 
		
		Если ДокументОбъект.Заблокирован() Тогда
			
			ДокументОбъект.Разблокировать();
			
		КонецЕсли; 
		
	КонецЦикла; // Для Каждого ТекДокумент Из МассивДокументов Цикл
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура СделатьЗаписьЖР(Сообщение)

	#Если Сервер Тогда
		ЗаписьЖурналаРегистрации("Трансляция загруженных данных из Аксапты. Обработка" 
		,УровеньЖурналаРегистрации.Информация 
		,
		,
		,Сообщение);
	#КонецЕсли 

КонецПроцедуры

&НаСервере
Функция ОтменитьТрансляцию(ДокументСсылка, РегистрыПриемники, Позиция)
	
	ОК_ОбщегоНазначения.ВыводСтатусаСообщения(,Строка(Позиция) + ") По документу: " + Строка(ДокументСсылка));
	
	МетаданныеДокумента = ДокументСсылка.Метаданные();
	
	ДействиеВыполнено = Истина;
	
	Для Каждого ТекРегистр Из РегистрыПриемники Цикл
		
		Если ТекРегистр.ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.РегистрБухгалтерии Тогда
			МенеджерРегистра = бит_ОбщегоНазначения.ПолучитьМенеджер("РегистрыБухгалтерии");
			ПредставлеРегистра = "движения регистра бухгалтерии";
			
		ИначеЕсли ТекРегистр.ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.РегистрНакопления Тогда
			МенеджерРегистра = бит_ОбщегоНазначения.ПолучитьМенеджер("РегистрыНакопления");
			ПредставлеРегистра = "движения регистра накопления";
			
		Иначе
			МенеджерРегистра = Неопределено;
		КонецЕсли;
		
		Если МенеджерРегистра = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НаборДляОчистки = МенеджерРегистра[ТекРегистр.ИмяОбъекта].СоздатьНаборЗаписей();
		НаборДляОчистки.Отбор.Регистратор.Установить(ДокументСсылка);
		НаборДляОчистки.Прочитать();
		
		Если НаборДляОчистки.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НаборДляОчистки.Очистить();
		
		// Запишем очищенный набор записей.
		флВыполненаЗапись = бит_ОбщегоНазначения.ЗаписатьНаборЗаписейРегистра(НаборДляОчистки);
		Если Не флВыполненаЗапись Тогда
			
			Если ДействиеВыполнено Тогда
				ДействиеВыполнено = Ложь;
			КонецЕсли;
			
			// Не успешная запись.
			Сообщить("	- не отменены " + ПредставлеРегистра + ": """ + ТекРегистр.Наименование + """.");
			
		Иначе
			// Успешная запись.
			Сообщить("	- отменены " + ПредставлеРегистра + ": """ + ТекРегистр.Наименование + """.");
			
			Если МетаданныеДокумента.Движения.Содержит(Метаданные.РегистрыСведений.бит_СоответствиеЗаписейТрансляции) Тогда
				
				// очистим соответствие номеров движений
				НаборСоответствие = РегистрыСведений.бит_СоответствиеЗаписейТрансляции.СоздатьНаборЗаписей();
				НаборСоответствие.Отбор.Регистратор.Установить(ДокументСсылка);
				НаборСоответствие.Прочитать();
				
				бит_МеханизмТрансляции.ОчиститьСоответствиеДвижений(НаборСоответствие,,ТекРегистр);
				
				бит_ОбщегоНазначения.ЗаписатьНаборЗаписейРегистра(НаборСоответствие);			
				
			КонецЕсли; 
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДействиеВыполнено;
	
КонецФункции // ОтменитьТрансляцию()
//-- СВВ}
