
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);
	
	// Заполним список типов для быстрого выбора составных типов.
	МассивТипов  = Метаданные.РегистрыСведений.бит_НастройкиПользователей.Измерения.Пользователь.Тип.Типы();
	СписокТиповПользователь = бит_ОбщегоНазначения.ПодготовитьСписокВыбораТипа(МассивТипов);
	
	фКэшЗначений = Новый Структура;
	фКэшЗначений.Вставить("ВидОбъектаРегистрБухгалтерии" ,Перечисления.бит_ВидыОбъектовСистемы.РегистрБухгалтерии);
	фКэшЗначений.Вставить("СписокТиповПользователь"      ,СписокТиповПользователь);
	фКэшЗначений.Вставить("Настройка_ОсновнаяГруппа"	 , ПланыВидовХарактеристик.бит_НастройкиПользователей.ОсновнаяГруппаПользователя);
	фКэшЗначений.Вставить("Настройка_ОсновнойРегистрУУ"  ,ПланыВидовХарактеристик.бит_НастройкиПользователей.ОсновнойРегистрБухгалтерииУУ);
	фКэшЗначений.Вставить("СписокУправленческихРегистров",СформироватьСписокУправленческихРегистровБухгалтерии());
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НастройкаПриИзменении(Элемент)
	
	ИзменениеНастройки();
		
КонецПроцедуры

&НаКлиенте
Процедура ПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
	                                                   ,Элемент
	                                                   ,Запись
	                                                   ,"Пользователь"
													   ,фКэшЗначений.СписокТиповПользователь
													   ,СтандартнаяОбработка);

	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательОчистка(Элемент, СтандартнаяОбработка)
	
	Элемент.ВыбиратьТип = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеНастройкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Запись.Настройка = фКэшЗначений.Настройка_ОсновнаяГруппа Тогда
		
		СтандартнаяОбработка = Ложь;
		ВыбратьОсновнуюГруппуПользователя(Запись.Пользователь, Запись, Элемент);
		
	ИначеЕсли Запись.Настройка = фКэшЗначений.Настройка_ОсновнойРегистрУУ Тогда
		
		// Для настройки ОсновнойРегистрУУ откроем форму выбора объектов системы с ограниченным 
		// перечнем объектов - управленческими регистрами бухгалтерии.
		СтандартнаяОбработка = Ложь;
		
		СписокВидовОбъектов = Новый СписокЗначений;
		СписокВидовОбъектов.Добавить(фКэшЗначений.ВидОбъектаРегистрБухгалтерии);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВидыОбъектов"           , СписокВидовОбъектов);
		ПараметрыФормы.Вставить("ТекущийОбъектСистемы"   , Запись.ЗначениеНастройки);
		ПараметрыФормы.Вставить("ДоступныеОбъектыСистемы", фКэшЗначений.СписокУправленческихРегистров);
		ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораОбъектовСистемыУправляемая", ПараметрыФормы, Элемент);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура открывает форму выбора основной группы пользователя.
//
// Параметры:
//  Пользователь   - СправочникСсылка.Пользователи.
//  ТекущиеДанные  - ТекущиеДанные.
//  Элемент        - Элемент.
//
&НаКлиенте
Процедура ВыбратьОсновнуюГруппуПользователя(Пользователь, ТекущиеДанные, Элемент)

	ПараметрыФормы = Новый Структура("Пользователь, ТекущаяГруппа", Пользователь, Запись.ЗначениеНастройки);
	
	Обработчик = Новый ОписаниеОповещения("ВыбратьОсновнуюГруппуПользователяЗавершение", ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	ОткрытьФорму("Обработка.бит_РедактированиеНастроекПользователей.Форма.ФормаСпискаДоступныхГруппУправляемая",ПараметрыФормы,Элемент,,,, Обработчик, Режим);

КонецПроцедуры // ВыбратьОсновнуюГруппуПользователя()

// Процедура - завершение выбора основной группы пользователя.
// 
&НаКлиенте
Процедура ВыбратьОсновнуюГруппуПользователяЗавершение(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		Запись.ЗначениеНастройки = Результат;
		
	КонецЕсли; 
	
КонецПроцедуры

// Функция формирует список управленческих регистров бухгалтерии.
//
// Возвращаемое значение:
//   СписокОбъектовСистемы - СписокЗначений.
//
&НаСервере
Функция СформироватьСписокУправленческихРегистровБухгалтерии()

	СписокОбъектовСистемы = Новый СписокЗначений;
	
	Если бит_ОбщегоНазначения.ЭтоУУ() Тогда
		
		РегистрыМета = Новый Массив;
		РегистрыМета.Добавить(Метаданные.РегистрыБухгалтерии.бит_Дополнительный_1);
		РегистрыМета.Добавить(Метаданные.РегистрыБухгалтерии.бит_Дополнительный_2);
		РегистрыМета.Добавить(Метаданные.РегистрыБухгалтерии.бит_Дополнительный_3);
		РегистрыМета.Добавить(Метаданные.РегистрыБухгалтерии.бит_Дополнительный_4);
		РегистрыМета.Добавить(Метаданные.РегистрыБухгалтерии.бит_Дополнительный_5);
		
		Для каждого МетаОбъект Из РегистрыМета Цикл
			
			ОбъектСистемы = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(МетаОбъект);
			Если ЗначениеЗаполнено(ОбъектСистемы) Тогда
				
				СписокОбъектовСистемы.Добавить(ОбъектСистемы)
				
			КонецЕсли; 
			
		КонецЦикла; 
		
	КонецЕсли;
	
	Возврат СписокОбъектовСистемы;
	
КонецФункции // СформироватьСписокУправленческихРегистровБухгалтерии()

// Процедура обрабатывает изменение настройки. Значение настройки приводится к типу настройки.
// 
&НаСервере
Процедура ИзменениеНастройки()

	Запись.ЗначениеНастройки = Запись.Настройка.ТипЗначения.ПривестиЗначение(Запись.ЗначениеНастройки);

КонецПроцедуры // ИзменениеНастройки()

#КонецОбласти 
