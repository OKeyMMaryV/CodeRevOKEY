#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// Вызывается непосредственно до записи объекта в базу данных
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-03-10 (#4054)
	//Перенос из регистра установленные визы в ТЧ инициаторы, т.к. в процессе согласования могли быть ручные изменения виз. При переносе должна сохраниться позиция галочки ОтветственныйЗаНомерЗаявки.
	Если (ДополнительныеСвойства.Свойство("РучноеИзменениеСтатуса") И ДополнительныеСвойства.РучноеИзменениеСтатуса)
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-05-20 (#4117)
		//ИЛИ (Ссылка.ок_Статус = ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.НаСогласование") 
		//	И ок_Статус = ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.Новый")) Тогда
		ИЛИ (ЗначениеЗаполнено(Ссылка)
			И Ссылка.ок_Статус <> ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.Новый") 
			И ок_Статус = ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.Новый")) Тогда
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-05-20 (#4117) 		
		
		МассивИДОтветственых = ок_Инициаторы.Выгрузить(Новый Структура("ОтветственныйЗаНомерЗаявки", Истина),"ИД").ВыгрузитьКолонку("ИД");
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-04-09 (#4122)
		//ок_Инициаторы.Очистить();
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-04-09 (#4122) 
				
		СтруктураОтбор = Новый Структура;
		СтруктураОтбор.Вставить("Объект",Ссылка);
		НаборВизы = бит_Визирование.ПрочитатьНаборВиз(СтруктураОтбор);
		
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-04-09 (#4122)
		Если НаборВизы.Количество() > 0 Тогда
			ок_Инициаторы.Очистить();
		КонецЕсли;
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-04-09 (#4122) 
		
		ДополнительныеСвойства.Вставить("НаборВизы",НаборВизы);		
		Для Каждого СтрокаВизы Из НаборВизы Цикл
			
			Если СтрокаВизы.Виза = ПредопределенноеЗначение("Справочник.бит_Визы.ок_Инициатор") 
				И СтрокаВизы.ФизическоеЛицо <> ПредопределенноеЗначение("Справочник.бит_БК_Инициаторы.СБ_НеЗадан") Тогда 	
								
				СтрокаИнициатора = ок_Инициаторы.Добавить();						
				СтрокаИнициатора.Инициатор = СтрокаВизы.ФизическоеЛицо;
				СтрокаИнициатора.ИД = СтрокаВизы.ИД;
				Если МассивИДОтветственых.Найти(СтрокаВизы.ИД) <> Неопределено Тогда 
					СтрокаИнициатора.ОтветственныйЗаНомерЗаявки = Истина;
				КонецЕсли;				
			КонецЕсли;
			
		КонецЦикла;		
	КонецЕсли;				
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-03-10 (#4054)

	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-26 (#3997)
	////ОКЕЙ Бублик А.А.(СофтЛаб) Начало 2020-09-16 (#3862) - при получении статусов по почте документ записывается в режиме ОбменДанными.Загрузка = Истина;
	//СтруктураРеквизитовДок = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ок_Статус");
	//Если Не ЗначениеЗаполнено(СтруктураРеквизитовДок.ок_Статус) Тогда
	//	СтруктураРеквизитовДок.ок_Статус = Перечисления.ок_СтатусыВходящегоЭлектронногоДокументооборота.ПустаяСсылка();
	//КонецЕсли;
	//ДополнительныеСвойства.Вставить("ТекущийСтатусДокумента", СтруктураРеквизитовДок.ок_Статус);
	////ОКЕЙ Бублик А.А.(СофтЛаб) Конец 2020-09-16 (#3862)
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		ДополнительныеСвойства.Вставить("НовыйДокумент", Истина);
		ДополнительныеСвойства.Вставить("ТекущийСтатусДокумента", ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.ПустаяСсылка"));
	Иначе
		ДополнительныеСвойства.Вставить("ТекущийСтатусДокумента", Ссылка.ок_Статус);
	КонецЕсли;
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-04-09 (#4122)	
	//Если ок_Инициаторы.Количество() > 0 
	//	И ок_Инициатор <> ок_Инициаторы[0].Инициатор Тогда
	//	ок_Инициатор = ок_Инициаторы[0].Инициатор;
	//КонецЕсли;
	Если ок_Инициаторы.Количество() > 0 Тогда
		Если ок_Инициатор <> ок_Инициаторы[0].Инициатор Тогда
			ок_Инициатор = ок_Инициаторы[0].Инициатор;
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(ок_Инициатор) Тогда
		ок_Инициатор = "";	
	КонецЕсли;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-04-09 (#4122)
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-26 (#3997) 
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-03-19 (#4054)
	Для Каждого СтрокаИнициатор Из ок_Инициаторы Цикл
		Если Не ЗначениеЗаполнено(СтрокаИнициатор.ИД) Тогда
			СтрокаИнициатор.ИД = Новый УникальныйИдентификатор();
		КонецЕсли;		
	КонецЦикла;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-03-19 (#4054) 
		
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоНовый() Тогда
		
		Если ВидЭД = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
			Если Не ЗначениеЗаполнено(НаименованиеДокументаОтправителя) Тогда
				НаименованиеДокументаОтправителя = ТипДокумента;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(ДатаДокументаОтправителя) Тогда
				ДатаДокументаОтправителя = НачалоДня(Дата);
			КонецЕсли;
			Если Не ЗначениеЗаполнено(НомерДокументаОтправителя) Тогда
				НомерДокументаОтправителя = Номер;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьИсториюОбработки();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ОчиститьИсториюОбработки();
	
КонецПроцедуры

//ОКЕЙ Бублик А.А.(СофтЛаб) Начало 2020-09-16 (#3862)
Процедура ПриЗаписи(Отказ)
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-26 (#3997) 
	////при получении статусов по почте документ записывается в режиме ОбменДанными.Загрузка = Истина;
	//Если ДополнительныеСвойства.Свойство("ТекущийСтатусДокумента")
	//	И ТипЗнч(ДополнительныеСвойства.ТекущийСтатусДокумента) = Тип("ПеречислениеСсылка.ок_СтатусыВходящегоЭлектронногоДокументооборота")
	//	И ДополнительныеСвойства.ТекущийСтатусДокумента <> ок_Статус Тогда
	//	
	//	бит_Визирование.УстановитьСтатусОбъекта(Ссылка, 
	//											Перечисления.бит_ВидыСтатусовОбъектов.Статус,
	//											ок_Статус,
	//											ДополнительныеСвойства.ТекущийСтатусДокумента,
	//											ПользователиКлиентСервер.ТекущийПользователь(),
	//											ТекущаяДата());
	//	
	//КонецЕсли;
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-26 (#3997) 

	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-02-02 (#3997)
	Если ДополнительныеСвойства.Свойство("РучноеИзменениеСтатуса") И ДополнительныеСвойства.РучноеИзменениеСтатуса Тогда
		
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-03-10 (#4054)
		Если ДополнительныеСвойства.Свойство("НаборВизы") Тогда
			НаборВизы = ДополнительныеСвойства.НаборВизы;
		Иначе
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-03-10 (#4054)
			СтруктураОтбор = Новый Структура;
			СтруктураОтбор.Вставить("Объект",Ссылка);
			
			НаборВизы = бит_Визирование.ПрочитатьНаборВиз(СтруктураОтбор);
		
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-03-10 (#4054)
		КонецЕсли;
		//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-03-10 (#4054)
		
		Если НаборВизы.Количество() <> 0 Тогда	
			
			ШаблонСообщения = бит_БК_Общий.ПолучитьЗначениеНастройкиБК("Согласование по почте", "Шаблон отмены входящего электронного документа");			
			Если Не ЗначениеЗаполнено(ШаблонСообщения) Тогда
				ЗаписьЖурналаРегистрации("ЗаписьВходящегоДокумента", УровеньЖурналаРегистрации.Ошибка,,,"Не заполнена настройка: Согласование по почте/Шаблон отмены входящего электронного документа");
			КонецЕсли;
			
			Для Каждого СтрокаВизы Из НаборВизы Цикл
				
				Если НЕ ЗначениеЗаполнено(СтрокаВизы.Решение) Тогда
								
					СообщениеОбОшибке = "";
			
					Результат = ок_ОбменСКонтрагентамиВнутренний.ОтправитьПисьмоПоВходящемуЭлектронномуДокументу(СтрокаВизы.Объект,СтрокаВизы.Виза,,СообщениеОбОшибке,,ШаблонСообщения,,СтрокаВизы.ФизическоеЛицо);
					Если НЕ Результат Тогда	
						ЗаписьЖурналаРегистрации("ЗаписьВходящегоДокумента", УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
					КонецЕсли;
										
				КонецЕсли;
								
			КонецЦикла;
			
			НаборВизы.Очистить();
			НаборВизы.Записать();
		КонецЕсли;
					
	КонецЕсли;
	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-05-18 (#4194)
	//Если (ДополнительныеСвойства.Свойство("НовыйДокумент") И ДополнительныеСвойства.НовыйДокумент)
	//	ИЛИ (ДополнительныеСвойства.Свойство("РучноеИзменениеСтатуса") И ДополнительныеСвойства.РучноеИзменениеСтатуса)
	//	ИЛИ (ок_Статус = ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.Отправлен"))
	//	ИЛИ (ок_Статус = ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.Завершен"))Тогда
	ЭтоНовыйДокумент = ДополнительныеСвойства.Свойство("НовыйДокумент") И ДополнительныеСвойства.НовыйДокумент;
	ЭтоРучноеИзменениеСтатуса = ДополнительныеСвойства.Свойство("РучноеИзменениеСтатуса") И ДополнительныеСвойства.РучноеИзменениеСтатуса;
	// ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2021-10-14 (#4324)
	Если ДополнительныеСвойства.Свойство("ТекущийСтатусДокумента")
		И ДополнительныеСвойства.ТекущийСтатусДокумента <> ок_Статус
		И ТипЭлементаВерсииЭД = Перечисления.ТипыЭлементовВерсииЭД.ок_Корреспонденция
		И ок_Статус = Перечисления.ок_СтатусыВходящегоЭлектронногоДокументооборота.Подписать Тогда 
		ОбщегоНазначения.СообщитьПользователю("Данный ЭД является корреспонденцией. Письмо нельзя отправить на подпись. Для завершения работы с данным ЭД установите статус «Завершен без подписания»",,,,Отказ);			
	// ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2021-10-14 (#4324)
	ИначеЕсли ДополнительныеСвойства.Свойство("ТекущийСтатусДокумента")
		И ДополнительныеСвойства.ТекущийСтатусДокумента <> ок_Статус
	// ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2021-10-14 (#4324)
		И Не ДополнительныеСвойства.Свойство("СинхронизацияСтатуса")
	// ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2021-10-14 (#4324)
		И (ЭтоНовыйДокумент
		 	ИЛИ ЭтоРучноеИзменениеСтатуса
			ИЛИ ок_Статус = ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.Отправлен")
			ИЛИ ок_Статус = ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.Завершен")
	// ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2021-10-14 (#4324)
			ИЛИ ДополнительныеСвойства.ТекущийСтатусДокумента = ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.ЗавершенБезПодписания")
	// ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2021-10-14 (#4324)
			ИЛИ ДополнительныеСвойства.ТекущийСтатусДокумента = ПредопределенноеЗначение("Перечисление.ок_СтатусыВходящегоЭлектронногоДокументооборота.Завершен")) Тогда
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-05-18 (#4194)		
		бит_Визирование.УстановитьСтатусОбъекта(Ссылка, 
												Перечисления.бит_ВидыСтатусовОбъектов.Статус,
												ок_Статус,
												ДополнительныеСвойства.ТекущийСтатусДокумента,
												бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"),
												ТекущаяДата());

	КонецЕсли;	
	//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-02-02 (#3997) 
	
КонецПроцедуры
//ОКЕЙ Бублик А.А.(СофтЛаб) Конец 2020-09-16 (#3862)

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьИсториюОбработки() 
	
	СостоянияПолучен = Новый Массив;
	СостоянияПодписан = Новый Массив;
	СостоянияАннулирован = Новый Массив;
	
	ДатаСеанса = ТекущаяДатаСеанса();
	
	СостоянияПодписан.Добавить(Перечисления.СостоянияВерсийЭД.ОбменЗавершен);
	СостоянияПодписан.Добавить(Перечисления.СостоянияВерсийЭД.ОбменЗавершенСИсправлением);
	СостоянияПодписан.Добавить(Перечисления.СостоянияВерсийЭД.ОжидаетсяОтправка);
	СостоянияПодписан.Добавить(Перечисления.СостоянияВерсийЭД.ОжидаетсяПередачаОператору);
	СостоянияПодписан.Добавить(Перечисления.СостоянияВерсийЭД.ОжидаетсяОтправкаПолучателю);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СостоянияПолучен, СостоянияПодписан);
	СостоянияПолучен.Добавить(Перечисления.СостоянияВерсийЭД.ЗакрытПринудительно);
	СостоянияПолучен.Добавить(Перечисления.СостоянияВерсийЭД.НаПодписи);
	СостоянияПолучен.Добавить(Перечисления.СостоянияВерсийЭД.НаУтверждении);
	
	СостоянияАннулирован.Добавить(Перечисления.СостоянияВерсийЭД.Аннулирован);
	
	Если Не ЗначениеЗаполнено(ДатаПолучения)
		И СостоянияПолучен.Найти(СостояниеЭДО) <> Неопределено Тогда
		ДатаПолучения = ДатаСеанса;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаПодписания)
		И СостоянияПодписан.Найти(СостояниеЭДО) <> Неопределено Тогда
		ДатаПодписания = ДатаСеанса;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаАннулирования)
		И СостоянияАннулирован.Найти(СостояниеЭДО) <> Неопределено Тогда
		ДатаАннулирования = ДатаСеанса;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьИсториюОбработки()
	
	ДатаПолучения = Дата(1, 1, 1);
	ДатаПодписания = Дата(1, 1, 1);
	ДатаАннулирования = Дата(1, 1, 1);
	
КонецПроцедуры

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-18 (#3997)
// Процедура устанавливает статус документа.
// 
// Параметры:
//  РежимЗаписи - РежимЗаписиДокумента.
// 
Процедура УстановитьСтатус() Экспорт
	
	СтрАлгоритмы              = бит_уп_Сервер.ПолучитьАлгоритмыОбъектаСистемы(ЭтотОбъект, ПредопределенноеЗначение("Перечисление.бит_уп_ВидыАлгоритмов.ИзменениеСтатусовОбъектов"));
	мАлгоритмИзмененияСтатуса = СтрАлгоритмы.ИзменениеСтатусовОбъектов;
	КомментироватьВыполнение  = бит_УправлениеПользователямиСервер.ПолучитьЗначениеПоУмолчанию("КомментироватьХодВыполненияАлгоритмовПроцессов", бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"));
			
	РежимСообщений = ?(КомментироватьВыполнение,"Все","Ошибки");			
			
	СтруктураКонтекст = Новый Структура;
	СтруктураКонтекст.Вставить("ТекущийОбъект",ЭтотОбъект);
	бит_уп_Сервер.ВыполнитьАлгоритм(мАлгоритмИзмененияСтатуса,СтруктураКонтекст,РежимСообщений);

КонецПроцедуры 

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ок_ТребуетсяЗаявка1С Тогда
		
		Если ок_Инициаторы.Количество() = 1 И НЕ ок_Инициаторы[0].ОтветственныйЗаНомерЗаявки Тогда
			ок_Инициаторы[0].ОтветственныйЗаНомерЗаявки = Истина;			
		КонецЕсли;
		
		Если ок_Инициаторы.Количество() > 1 И ок_Инициаторы.Найти(Истина,"ОтветственныйЗаНомерЗаявки") = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Требуется указать ответственного за № заявки",,,,Отказ);			
		КонецЕсли;		
		
	КонецЕсли;
	
КонецПроцедуры
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-01-18 (#3997) 

#КонецОбласти

#Иначе
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
	
#КонецЕсли