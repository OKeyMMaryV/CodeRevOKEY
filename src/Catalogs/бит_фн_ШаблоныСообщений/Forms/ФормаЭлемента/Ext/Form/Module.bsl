
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
    
	
	// Вызов механизма защиты
	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	мКэшЗначений = Новый Структура;
	// Кэшируем перечисления
	КэшПеречисления = Новый Структура;	
	СтрПеречисление = бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_ВидыОбъектовСистемы);
	
	КэшПеречисления.Вставить("бит_ВидыОбъектовСистемы",СтрПеречисление);
	
	СтрПеречисление = бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_фн_ВидыСобытийОповещений);
	КэшПеречисления.Вставить("бит_фн_ВидыСобытийОповещений",СтрПеречисление);
	
	мКэшЗначений.Вставить("Перечисления",КэшПеречисления);
	// Вид контактной информации
	Если бит_ОбщегоНазначения.ЭтоСемействоБП() Тогда	
		мКэшЗначений.Вставить("ВидКонтактнойИнформацииСлужебнаяПочта",Справочники.ВидыКонтактнойИнформации.EmailПользователя);
	КонецЕсли;
		
	// Список объектов на которые распространяется механизм визирования.
	СписокВизируемыхОбъектов = бит_Визирование.ВизируемыеОбъектыСистемы();
	мКэшЗначений.Вставить("СписокВизируемыхОбъектов",СписокВизируемыхОбъектов);	
	
	// Установим доступные типы текстов
	Для Каждого ТипТекста Из ТипТекстаПочтовогоСообщения Цикл
		Элементы.ТипТекстаСообщения.СписокВыбора.Добавить(Строка(ТипТекста));
	КонецЦикла;
	
	// Установка доступных видов событий
	ЭтоСемействоERP = бит_ОбщегоНазначения.ЭтоСемействоERP();
	бит_фн_ОповещенияСервер.ЗаполнитьСписокВыбораВидовСобытий(Элементы.ВидСобытия.СписокВыбора, ЭтоСемействоERP);	
		
	УстановитьВидимость();
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектСистемыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВидовОбъектов = Новый СписокЗначений;
	Если Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.ЗаписанСправочник Тогда
		ВидОбъектаСистемы = мКэшЗначений.Перечисления.бит_ВидыОбъектовСистемы.Справочник;
	ИначеЕсли Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.ИзмененоСостояниеПроцесса Тогда
		ВидОбъектаСистемы = мКэшЗначений.Перечисления.бит_ВидыОбъектовСистемы.БизнесПроцесс;
	ИначеЕсли Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.ИзмененоСостояниеЗадачи Тогда
		ВидОбъектаСистемы = мКэшЗначений.Перечисления.бит_ВидыОбъектовСистемы.Задача;
	Иначе	
		ВидОбъектаСистемы = мКэшЗначений.Перечисления.бит_ВидыОбъектовСистемы.Документ;
	КонецЕсли; 
	СписокВидовОбъектов.Добавить(ВидОбъектаСистемы);	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущийОбъектСистемы"   ,Объект.ОбъектСистемы);
	ПараметрыФормы.Вставить("ВидыОбъектов"           ,СписокВидовОбъектов);
	Если НеобходимоОграничитьСписокОбъектов() Тогда
		
		ПараметрыФормы.Вставить("ДоступныеОбъектыСистемы",мКэшЗначений.СписокВизируемыхОбъектов);	
		
	КонецЕсли; 
	ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораОбъектовСистемыУправляемая",ПараметрыФормы,Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидСобытияПриИзменении(Элемент)
	
	// Проверим соответствует ли объект системы виду события.
	Если Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.ЗаписанСправочник Тогда
		
		Если НЕ ВидОбъектаСистемы = мКэшЗначений.Перечисления.бит_ВидыОбъектовСистемы.Справочник Тогда
			
			Объект.ОбъектСистемы = Неопределено;
			
		КонецЕсли; 
	ИначеЕсли Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.ИзмененоСостояниеЗадачи Тогда
		
		Если НЕ ВидОбъектаСистемы = мКэшЗначений.Перечисления.бит_ВидыОбъектовСистемы.Задача Тогда
			
			Объект.ОбъектСистемы = Неопределено;
			
		КонецЕсли;
		
	ИначеЕсли Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.ИзмененоСостояниеПроцесса Тогда
		
		Если НЕ ВидОбъектаСистемы = мКэшЗначений.Перечисления.бит_ВидыОбъектовСистемы.БизнесПроцесс Тогда
			
			Объект.ОбъектСистемы = Неопределено;
			
		КонецЕсли;
		
	ИначеЕсли Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.ДокументыДляВизирования Тогда
		
		Объект.ОбъектСистемы = Неопределено;
		
	Иначе	
		
		Если НЕ ВидОбъектаСистемы = мКэшЗначений.Перечисления.бит_ВидыОбъектовСистемы.Документ Тогда
			
			Объект.ОбъектСистемы = Неопределено;
			
		КонецЕсли; 
		
		// События по визированию и изменению статусов распространяются на ограниченный список документов.
		Если ЗначениеЗаполнено(Объект.ОбъектСистемы) И  НеобходимоОграничитьСписокОбъектов() Тогда
			
			Если мКэшЗначений.СписокВизируемыхОбъектов.НайтиПоЗначению(Объект.ОбъектСистемы) = Неопределено Тогда
				
				Объект.ОбъектСистемы = Неопределено;
				
			КонецЕсли; 
			
		КонецЕсли; // Проверка на вхождение в список визируемых.
		
	КонецЕсли; // По виду события
	
	УстановитьОбъектПоВидуСобытия();
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура СпособТранспортаПриИзменении(Элемент)
	СпособТранспортаПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура СпособТранспортаПриИзмененииНаСервере()
	
	ЭтоПуш = ?(Объект.СпособТранспорта = Перечисления.бит_фн_СпособыТранспортаОповещений.PushNotification, Истина, Ложь);
	ЭтоТелеграм = ?(Объект.СпособТранспорта = Перечисления.бит_фн_СпособыТранспортаОповещений.Telegram, Истина, Ложь);
	
	
	Если ЭтоПуш ИЛИ ЭтоТелеграм Тогда
	
		Объект.ТипТекстаСообщения = "ПростойТекст";
	
	КонецЕсли; 
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Элемент.СписокВыбора.Очистить();
	
	Если Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.УстановленСтатус Тогда

		СтрВыбора = Строка(Объект.ВидСобытия) + " объекта """ + Строка(Объект.ОбъектСистемы) + """";

	ИначеЕсли Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.ПринятоРешение Тогда	

		СтрВыбора = Строка(Объект.ВидСобытия) + "  по визе объекта """ + Строка(Объект.ОбъектСистемы) + """";		

	Иначе	

		СтрВыбора = Строка(Объект.ВидСобытия) + " """ + Строка(Объект.ОбъектСистемы) + """";			

	КонецЕсли; 
  
	Элемент.СписокВыбора.Добавить(СтрВыбора);
	
КонецПроцедуры // НаименованиеНачалоВыбораИзСписка()

&НаКлиенте
Процедура НаименованиеАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Элемент.СписокВыбора.Очистить();
	
	Если Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.УстановленСтатус Тогда

		СтрВыбора = Строка(Объект.ВидСобытия) + " объекта """ + Строка(Объект.ОбъектСистемы) + """";

	ИначеЕсли Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.ПринятоРешение Тогда	

		СтрВыбора = Строка(Объект.ВидСобытия) + "  по визе объекта """ + Строка(Объект.ОбъектСистемы) + """";		

	Иначе	

		СтрВыбора = Строка(Объект.ВидСобытия) + " """ + Строка(Объект.ОбъектСистемы) + """";			

	КонецЕсли; 
  
	Элемент.СписокВыбора.Добавить(СтрВыбора);
	
КонецПроцедуры // НаименованиеАвтоПодбор()

&НаКлиенте
Процедура БейджиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокТипов = Новый СписокЗначений;
	СписокТипов.Добавить(Тип("Число"),  НСтр("ru = 'Число бейждей'"));
	СписокТипов.Добавить(Тип("Строка"),  НСтр("ru = 'Выражение'"));
	
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
	                                                   ,Элемент
	                                                   ,Объект
	                                                   ,"Бейджи"
													   ,СписокТипов
													   ,СтандартнаяОбработка);
													   
													   
		
	Элементы.Бейджи.КнопкаВыпадающегоСписка = ?(ТипЗнч(Объект.Бейджи) = Тип("Строка"), Истина, Ложь);
		
		
КонецПроцедуры

&НаКлиенте
Процедура БейджиОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.ВыбиратьТип = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура БейджиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ТипЗнч(Объект.Бейджи) = Тип("Строка") И Ожидание = 0 Тогда
		
		 СтандартнаяОбработка = Ложь;
		
		 ДанныеВыбора = Новый СписокЗначений;
		 ДанныеВыбора.Добавить("СтруктураКонтекст.ВыборкаДокументов.Количество()");
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВставитьШаблон(Команда)
	
	ПараметрыФормы = Новый Структура;
  	ПараметрыФормы.Вставить("ВидСобытия"   , Объект.ВидСобытия);
    ПараметрыФормы.Вставить("ОбъектСистемы", Объект.ОбъектСистемы);
	
	Обработчик = Новый ОписаниеОповещения("ВставитьШаблонЗавершение", ЭтотОбъект);
    Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
    ОткрытьФорму("Справочник.бит_фн_ШаблоныСообщений.Форма.ФормаШаблонаУправляемая",ПараметрыФормы,,,,, Обработчик, Режим);
	
КонецПроцедуры // ВставитьШаблон()

// Процедура обработчик оповещения "ВставитьШаблонЗавершение".
// 
// Параметры:
// СтрокаРезультат - Строка
// Параметры - Структура
// 
&НаКлиенте
Процедура ВставитьШаблонЗавершение(СтрокаРезультат, Параметры) Экспорт

	Если Лев(ТекущийЭлемент.Имя, 10) = "Сообщение_" Тогда
		ИмяРеквизита =  ТекущийЭлемент.Имя;
	Иначе	
		Возврат;
	КонецЕсли;
	
	ТекущийТекст = Объект[ИмяРеквизита];// Элементы[ИмяРеквизита].ТекстРедактирования;	
	
	Элементы[ИмяРеквизита].ВыделенныйТекст = СтрокаРезультат;
	
	ЭтаФорма.ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонПоУмолчанию(Команда)
	
	ЗаполнитьШаблонПоУмолчанию();
	
КонецПроцедуры

// Процедура заполняет шаблон сообщения по умолчанию. 
// 
// Параметры:
// 
&НаСервере
Процедура ЗаполнитьШаблонПоУмолчанию()

	Если Объект.СпособТранспорта = Перечисления.бит_фн_СпособыТранспортаОповещений.ЭлектроннаяПочта
		ИЛИ Объект.СпособТранспорта = Перечисления.бит_фн_СпособыТранспортаОповещений.ЭлектроннаяПочта1С Тогда
		
		Если Объект.ВидСобытия = Перечисления.бит_фн_ВидыСобытийОповещений.ОкончаниеСрокаДействияДоговора Тогда
			МакетПоУмолчанию = Справочники.бит_фн_ШаблоныСообщений.ПолучитьМакет("ШаблонПоУмолчаниюСрокДействия");
			
		Иначеесли Объект.ВидСобытия = Перечисления.бит_фн_ВидыСобытийОповещений.ДокументыДляВизирования Тогда
			МакетПоУмолчанию = Справочники.бит_фн_ШаблоныСообщений.ПолучитьМакет("ШаблонПоУмолчаниюВизирование");
			
		Иначе
			
			МакетПоУмолчанию = Справочники.бит_фн_ШаблоныСообщений.ПолучитьМакет("ШаблонПоУмолчанию");
			
		КонецЕсли;
		
		Объект.Сообщение_Текст = МакетПоУмолчанию.ПолучитьТекст();
		
		Объект.ТипТекстаСообщения = ТипТекстаПочтовогоСообщения.HTML;
		
	ИначеЕсли Объект.СпособТранспорта = Перечисления.бит_фн_СпособыТранспортаОповещений.PushNotification Тогда	
		
		Если Объект.ВидСобытия = Перечисления.бит_фн_ВидыСобытийОповещений.ДокументыДляВизирования Тогда
			
			Объект.Бейджи = "СтруктураКонтекст.ВыборкаДокументов.Количество()";
			Объект.Сообщение_Заголовок = "{%СтруктураКонтекст.ВыборкаДокументов.Количество()%} документов для визирования";
			Объект.Сообщение_Текст = "Вам доступно {%СтруктураКонтекст.ВыборкаДокументов.Количество()%} документов для визирования.";
			
		КонецЕсли; 
		
		Объект.ТипТекстаСообщения = ТипТекстаПочтовогоСообщения.ПростойТекст;
		
		
	КонецЕсли; 
	
КонецПроцедуры // ЗаполнитьШаблонПоУмолчанию()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость элементов формы.
// 
&НаСервере
Процедура УстановитьВидимость()
	
	ЭтоДокументыДляВизирования = ?(Объект.ВидСобытия = Перечисления.бит_фн_ВидыСобытийОповещений.ДокументыДляВизирования,Истина,Ложь);
	ЭтоПуш = ?(Объект.СпособТранспорта = Перечисления.бит_фн_СпособыТранспортаОповещений.PushNotification, Истина, Ложь);
	ЭтоТелеграм = ?(Объект.СпособТранспорта = Перечисления.бит_фн_СпособыТранспортаОповещений.Telegram, Истина, Ложь);
	
	
	Элементы.ОбъектСистемы.Доступность = НЕ ЭтоДокументыДляВизирования;
	
	Если Объект.ВидСобытия = Перечисления.бит_фн_ВидыСобытийОповещений.НапоминанияПоГрафикуНачислений 
		ИЛИ Объект.ВидСобытия = Перечисления.бит_фн_ВидыСобытийОповещений.НапоминанияПоГрафикуПлатежей 
		ИЛИ Объект.ВидСобытия = Перечисления.бит_фн_ВидыСобытийОповещений.ОкончаниеСрокаДействияДоговора 
		ИЛИ Объект.ВидСобытия = Перечисления.бит_фн_ВидыСобытийОповещений.ДокументыДляВизирования Тогда
		
		Элементы.ФормаШаблонПоУмолчанию.Видимость = Истина;
		
	Иначе
		
		Элементы.ФормаШаблонПоУмолчанию.Видимость = Ложь;

	КонецЕсли;
	
	Элементы.Сообщение_Подпись.Видимость = НЕ ЭтоПуш И НЕ ЭтоТелеграм;
	Элементы.ТипТекстаСообщения.Доступность = НЕ ЭтоПуш И НЕ ЭтоТелеграм;
	Элементы.Бейджи.Видимость = ЭтоПуш; 
	
КонецПроцедуры

// Процедура заполняет реквизит ОбъектСистемы некоторым значением по-умолчания для текущего вида события.
// 
&НаСервере
Процедура УстановитьОбъектПоВидуСобытия()
	
	Если Объект.ВидСобытия = Перечисления.бит_фн_ВидыСобытийОповещений.ДокументыДляВизирования Тогда
		
		МетаОбъект = Метаданные.Обработки.бит_РабочееМестоВизирования;
		
		Объект.ОбъектСистемы = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаОбъект);
		
	ИначеЕсли Объект.ВидСобытия = Перечисления.бит_фн_ВидыСобытийОповещений.ИзмененоСостояниеПроцесса Тогда
		
		МетаОбъект = Метаданные.БизнесПроцессы.бит_уп_Процесс;
		
		Объект.ОбъектСистемы = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаОбъект);
		
	ИначеЕсли Объект.ВидСобытия = Перечисления.бит_фн_ВидыСобытийОповещений.ИзмененоСостояниеЗадачи Тогда
		
		МетаОбъект = Метаданные.Задачи.бит_уп_Задача;
		
		Объект.ОбъектСистемы = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция НеобходимоОграничитьСписокОбъектов()

	Если Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.ПринятоРешение 
		ИЛИ Объект.ВидСобытия = мКэшЗначений.Перечисления.бит_фн_ВидыСобытийОповещений.УстановленСтатус Тогда
		
		флНеобходимоОграничить = Истина;	
		
	Иначе
		
		флНеобходимоОграничить = Ложь;
		
	КонецЕсли; 	

	Возврат флНеобходимоОграничить;
	
КонецФункции // НеобходимоОграничитьСписокОбъектов()

#КонецОбласти

