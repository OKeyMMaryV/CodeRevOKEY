////////////////////////////////////////////////////////////////////////////////
// Настройка периода - Структура, получаемая через параметры формы при создании:
// - ВариантНастройки,
// - ВариантНачала,
// - ВариантОкончания,
// - ВариантПериода,
// - ДатаНачала,
// - ДатаОкончания,
// - РедактироватьКакИнтервал,
// - РедактироватьКакПериод,
// - СмещениеНачала,
// - СмещениеОкончания.

// ВариантНастройки - Определяет закладку, на которой будет открыт диалог редактирования периода.
// Варианты настройки периода:
// 0 - Интервал, 
// 1 - Период.

// ВариантНачала, ВариантОкончания - Определяет вариант начала/окончания периода.
// Варианты границы интервала:
// 0 - БезОграничения, 
// 1 - Смещение,
// 2 - Год, 
// 3 - Квартал, 
// 4 - Месяц, 
// 5 - Неделя, 
// 6 - РабочаяДата,	
// 7 - КонкретнаяДата. 
	
// ВариантПериода - Содержит вариант периода настраиваемого интервала.
// Варианты периода:
// 0  - Год, 
// 1  - День, 
// 2  - ДеньСНачалаГода, 
// 3  - ДеньСНачалаКвартала, 
// 4  - ДеньСНачалаМесяца, 
// 5  - Квартал, 
// 6  - КварталСНачалаГода, 
// 7  - Месяц, 
// 8  - МесяцСНачалаГода ,
// 9  - МесяцСНачалаКвартала, 
// 10 - ПроизвольныйИнтервал. 

// ДатаНачала (Дата), 
// ДатаОкончания (Дата).

// РедактироватьКакИнтервал (Булево) - Определяет видимость закладки "Интервал" 
// в диалоге для визуальной настройки периода.
	
// РедактироватьКакПериод (Булево) - Определяет видимость закладки "Период" 
// в диалоге для визуальной настройки периода.    
	
// СмещениеНачала (Число) - Количество дней до рабочей даты для начала интервала.
// СмещениеОкончания (Число)- Количество дней после рабочей даты для конца интервала.


////////////////////////////////////////////////////////////////////////////////
// ВариантПериодаФорма:
// 0 - Год,
// 1 - Кварта,
// 2 - Месяц,
// 3 - День,
// 4 - Произвольный период.
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	              
	ЗаполнитьПоПараметрам(Параметры, Отказ); 	
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	ОбновитьИнфНадписи();

	Элементы.Интервал.Видимость = РедактироватьКакИнтервал;
	Элементы.Период.Видимость   = РедактироватьКакПериод;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = ?(ВариантНастройки = 0, Элементы.Интервал, Элементы.Период);
		
КонецПроцедуры // ПриОткрытии()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
 
&НаКлиенте
Процедура НачалоПериодаБезОграниченияПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантНачала, ДатаНачала);
	
	УстановитьПроизвольныйВариантПериода();
	
	УстановитьДоступность();
	ОбновитьИнфНадписи();

КонецПроцедуры // НачалоПериодаБезОграниченияПриИзменении()

&НаКлиенте
Процедура НачалоПериодаСмещениеНачалаПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантНачала, ДатаНачала);
	ДатаНачала = ДатаНачала - СмещениеНачала*60*60*24;

	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();

КонецПроцедуры // НачалоПериодаСмещениеНачалаПриИзменении()

&НаКлиенте
Процедура НачалоПериодаНачалоГодаПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантНачала, ДатаНачала);
	                           	
	УстановитьВариантПериода();  	
	УстановитьДоступность();	
	ОбновитьИнфНадписи();

КонецПроцедуры // НачалоПериодаНачалоГодаПриИзменении()

&НаКлиенте
Процедура НачалоПериодаНачалоКварталаПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантНачала, ДатаНачала);
	
	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // НачалоПериодаНачалоКварталаПриИзменении()

&НаКлиенте
Процедура НачалоПериодаНачалоМесяцаПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантНачала, ДатаНачала);

	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // НачалоПериодаНачалоМесяцаПриИзменении()

&НаКлиенте
Процедура НачалоПериодаНачалоНеделиПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантНачала, ДатаНачала);
	
	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // НачалоПериодаНачалоНеделиПриИзменении()

&НаКлиенте
Процедура НачалоПериодаНачалоДняПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантНачала, ДатаНачала);
	
	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // НачалоПериодаНачалоДняПриИзменении()

&НаКлиенте
Процедура НачалоПериодаПроизвольноПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантНачала, ДатаНачала);
	
	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // НачалоПериодаПроизвольноПриИзменении()

&НаКлиенте
Процедура СмещениеНачалаПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантНачала, ДатаНачала);
	ДатаНачала = ДатаНачала - СмещениеНачала*60*60*24;
	
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // СмещениеНачалаПриИзменении()

// Обработчики реквизитов "Конец периода"

&НаКлиенте
Процедура КонецПериодаБезОграниченияПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантОкончания, ДатаОкончания, Ложь);
	
	УстановитьПроизвольныйВариантПериода();
	
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // КонецПериодаБезОграниченияПриИзменении()

&НаКлиенте
Процедура КонецПериодаСмещениеОкончанияПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантОкончания, ДатаОкончания, Ложь);
	ДатаОкончания = ДатаОкончания + СмещениеОкончания*60*60*24;
	
	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // КонецПериодаСмещениеОкончанияПриИзменении()

&НаКлиенте
Процедура КонецПериодаКонецГодаПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантОкончания, ДатаОкончания, Ложь);
	
	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // КонецПериодаКонецГодаПриИзменении() 

&НаКлиенте
Процедура КонецПериодаКонецКварталаПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантОкончания, ДатаОкончания, Ложь);
	
	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // КонецПериодаКонецКварталаПриИзменении()

&НаКлиенте
Процедура КонецПериодаКонецМесяцаПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантОкончания, ДатаОкончания, Ложь);
	
	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // КонецПериодаКонецМесяцаПриИзменении()

&НаКлиенте
Процедура КонецПериодаКонецНеделиПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантОкончания, ДатаОкончания, Ложь);
	
	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // КонецПериодаКонецНеделиПриИзменении()

&НаКлиенте
Процедура КонецПериодаКонецДняПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантОкончания, ДатаОкончания, Ложь);
	
	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // КонецПериодаКонецДняПриИзменении()

&НаКлиенте
Процедура КонецПериодаПроизвольноПриИзменении(Элемент)
	
	УстановитьГраницуИнтервала(ВариантОкончания, ДатаОкончания, Ложь);
	
	УстановитьВариантПериода();
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // КонецПериодаПроизвольноПриИзменении()

&НаКлиенте
Процедура СмещениеОкончанияПриИзменении(Элемент)
	
	 УстановитьГраницуИнтервала(ВариантОкончания, ДатаОкончания, Ложь);
	 ДатаОкончания = ДатаОкончания + СмещениеОкончания*60*60*24;
	 
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // СмещениеОкончанияПриИзменении()

// Обработчики реквизитов "Период"

&НаКлиенте
Процедура ПериодГодПриИзменении(Элемент)
	
	ПериодСНачалаГода 	  = Ложь;
	ПериодСНачалаКвартала = Ложь;
	ПериодСНачалаМесяца   = Ложь;
	
	УстановитьПериод();
	
	УстановитьДоступность();
	ОбновитьИнфНадписи();  	
	
КонецПроцедуры // ПериодГодПриИзменении()
                
&НаКлиенте
Процедура ПериодКварталПриИзменении(Элемент)
	
	ПериодСНачалаКвартала = Ложь;
	ПериодСНачалаМесяца   = Ложь;
	
	УстановитьПериод();
	
	УстановитьДоступность();
	ОбновитьИнфНадписи(); 
	     
КонецПроцедуры // ПериодКварталПриИзменении()

&НаКлиенте
Процедура ПериодМесяцПриИзменении(Элемент)
	
	ПериодСНачалаМесяца = Ложь;
	
	УстановитьПериод();
	
	УстановитьДоступность();
	ОбновитьИнфНадписи();  
	
КонецПроцедуры // ПериодМесяцПриИзменении() 

&НаКлиенте
Процедура ПериодДеньПриИзменении(Элемент)
	
	УстановитьПериод();
	
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // ПериодДеньПриИзменении()

&НаКлиенте
Процедура ПроизвольныйПериодПриИзменении(Элемент)
	
	УстановитьПериод();
	
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // ПроизвольныйПериодПриИзменении()

&НаКлиенте
Процедура РабочийПериодПриИзменении(Элемент)
	
	Если РабочийПериод Тогда
	 	ДатаОкончания = ТекущаяДата();
		УстановитьПервоначальныеЗначенияПериодов();
		УстановитьПериод();
	Иначе
		УстановитьИнтервал();
	КонецЕсли;	
	
	УстановитьДоступность();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // РабочийПериодПриИзменении()

&НаКлиенте
Процедура ДатаГодПриИзменении(Элемент)
	
	УстановитьПериод();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // ДатаГодПриИзменении()

&НаКлиенте
Процедура ДатаКварталРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДатаКвартал = ДобавитьМесяц(ДатаКвартал, Направление*3);
	
	УстановитьПериод();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // ДатаКварталРегулирование()  

&НаКлиенте
Процедура ДатаМесяцРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДатаМесяц = ДобавитьМесяц(ДатаМесяц, Направление);
	
	УстановитьПериод();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // ДатаМесяцРегулирование()

&НаКлиенте
Процедура ДатаДеньПриИзменении(Элемент)
	
	УстановитьПериод();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // ДатаДеньПриИзменении()
 
&НаКлиенте
Процедура ПериодСНачалаГодаПриИзменении(Элемент)
	
	Если ПериодСНачалаГода Тогда
		
		ПериодСНачалаКвартала = Ложь;
		ПериодСНачалаМесяца   = Ложь;
		
	КонецЕсли; 
	
	УстановитьПериод();
	ОбновитьИнфНадписи();
	
КонецПроцедуры // ПериодСНачалаГодаПриИзменении()

&НаКлиенте
Процедура ПериодСНачалаМесяцаПриИзменении(Элемент)
	
	Если ПериодСНачалаМесяца Тогда 
		
		ПериодСНачалаГода     = Ложь;  
		ПериодСНачалаКвартала = Ложь;
		
	КонецЕсли; 
	
	УстановитьПериод();
	ОбновитьИнфНадписи();

КонецПроцедуры // ПериодСНачалаМесяцаПриИзменении()
 
&НаКлиенте
Процедура ПериодСНачалаКварталаПриИзменении(Элемент)
	
	Если ПериодСНачалаКвартала Тогда   
		
		ПериодСНачалаГода   = Ложь;  
		ПериодСНачалаМесяца = Ложь;  
		
	КонецЕсли; 
	
	УстановитьПериод();
	ОбновитьИнфНадписи();

КонецПроцедуры // ПериодСНачалаКварталаПриИзменении()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоКнопкеОК(Команда)
	
	// Проверка корректности интервала.
	// Дата начала должна быть меньше или равна дате окончания.
	ВремяКорректно = бит_ОбщегоНазначенияКлиентСервер.ВременнойИнтервалКорректный(ДатаНачала, 
																					  ДатаОкончания);
																					  
	Если ВремяКорректно Тогда
		
		ПараметрЗакрытия = Новый Структура;
		ПараметрЗакрытия.Вставить("ДатаНачала",    ДатаНачала);
		ПараметрЗакрытия.Вставить("ДатаОкончания", ДатаОкончания);
		
		НастройкаПериода = Новый Структура;
		
		НастройкаПериода.Вставить("ВариантНастройки"		, ВариантНастройки); 
		НастройкаПериода.Вставить("ВариантНачала"			, ВариантНачала);
		НастройкаПериода.Вставить("ВариантОкончания"		, ВариантОкончания);
		НастройкаПериода.Вставить("ВариантПериода"			, ВариантПериода);
		НастройкаПериода.Вставить("ДатаНачала"				, ДатаНачала);
		НастройкаПериода.Вставить("ДатаОкончания"			, ДатаОкончания);
		НастройкаПериода.Вставить("РедактироватьКакИнтервал", РедактироватьКакИнтервал);
		НастройкаПериода.Вставить("РедактироватьКакПериод"	, РедактироватьКакПериод);
		НастройкаПериода.Вставить("СмещениеНачала"			, СмещениеНачала);
		НастройкаПериода.Вставить("СмещениеОкончания"		, СмещениеОкончания);
	
		ПараметрЗакрытия.Вставить("НастройкаПериода", НастройкаПериода);
		
		Закрыть(ПараметрЗакрытия);
	
	КонецЕсли;                    
	
КонецПроцедуры // ПоКнопкеОК()

&НаКлиенте
Процедура ПоКнопкеОтмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры // ПоКнопкеОтмена()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет реквизиты формы по параметрам формы.
// 
&НаСервере 
Процедура ЗаполнитьПоПараметрам(ПараметрыНастройки, Отказ)
	
	РедактироватьКакИнтервал = ПолучитьСвойствоСтруктуры(ПараметрыНастройки, "РедактироватьКакИнтервал", Истина);
	РедактироватьКакПериод   = ПолучитьСвойствоСтруктуры(ПараметрыНастройки, "РедактироватьКакПериод", Истина);
	
	ВариантНастройки = ПолучитьСвойствоСтруктуры(ПараметрыНастройки, "ВариантНастройки", 0);
	
	Если (НЕ РедактироватьКакИнтервал И ВариантНастройки = 0) 
	 ИЛИ (НЕ РедактироватьКакПериод И ВариантНастройки = 1) Тогда
	 
		// Неверный параметр "ВариантНастройки"
		Отказ = Истина;
	    Возврат;
	КонецЕсли;
	
	ВариантНачала    = ПолучитьСвойствоСтруктуры(ПараметрыНастройки, "ВариантНачала", 7);
	ВариантОкончания = ПолучитьСвойствоСтруктуры(ПараметрыНастройки, "ВариантОкончания", 7);
		
	СмещениеНачала    = ПолучитьСвойствоСтруктуры(ПараметрыНастройки, "СмещениеНачала", 0);
	СмещениеОкончания = ПолучитьСвойствоСтруктуры(ПараметрыНастройки, "СмещениеОкончания", 0);
	
	ДатаНачала    = ПолучитьСвойствоСтруктуры(ПараметрыНастройки, "ДатаНачала",    '00010101');
	ДатаОкончания = ПолучитьСвойствоСтруктуры(ПараметрыНастройки, "ДатаОкончания", '00010101');
	
	УстановитьВариантПериодаПоНастройке(ПараметрыНастройки);
	УстановитьПроизвольныйВариантПериода();
	УстановитьПервоначальныеЗначенияПериодов();
	
КонецПроцедуры // ЗаполнитьПоПараметрам()
 
// Процедура устанавливет вариант периода по параметрам, переданным при открытии формы.
// 
&НаСервере
Процедура УстановитьВариантПериодаПоНастройке(ПараметрыНастройки)
	
	ВариантПериода = ПолучитьСвойствоСтруктуры(ПараметрыНастройки, "ВариантПериода", 10);
	Если ВариантПериода = 0 Тогда 							   // 0 -> 0
		ВариантПериодаФорма = 0 ;
	ИначеЕсли ВариантПериода >= 1 И ВариантПериода <= 4 Тогда  // 1, 2, 3, 4 -> 3
		ВариантПериодаФорма = 3 ;
	ИначеЕсли ВариантПериода >= 5 И ВариантПериода <= 6 Тогда  // 5, 6 -> 1
		ВариантПериодаФорма = 1 ;
	ИначеЕсли ВариантПериода >= 7 И ВариантПериода <= 9 Тогда  // 7, 8, 9 -> 2
		ВариантПериодаФорма = 2 ;
	ИначеЕсли ВариантПериода = 10 Тогда  					   // 10 -> 4
		ВариантПериодаФорма = 4 ;
	КонецЕсли;
	            	
	УстановитьНачальноеОграничение();
			
КонецПроцедуры // УстановитьВариантПериодаПоНастройке()

// Процедура устанавливает значения ПериодСНачалаГода, ПериодСНачалаКвартала, ПериодСНачалаМесяца.
// 
// Параметры:
//  Нет
// 
&НаСервере
Процедура УстановитьНачальноеОграничение()

	ПериодСНачалаГода 		= ВариантПериода = 2 ИЛИ ВариантПериода = 6 ИЛИ ВариантПериода = 8;
	ПериодСНачалаКвартала 	= ВариантПериода = 3 ИЛИ ВариантПериода = 9;
	ПериодСНачалаМесяца 	= ВариантПериода = 4;	

КонецПроцедуры // УстановитьНачальноеОграничение()
        
// Устанавливает вариант периода в зависимости от даты начала и даты окончания.
// 
&НаСервере
Процедура УстановитьПроизвольныйВариантПериода()

	 Если НЕ ЗначениеЗаполнено(ДатаНачала) И НЕ ЗначениеЗаполнено(ДатаОкончания) Тогда
	
		 ВариантПериодаФорма = 4; // ПроизвольныйИнтервал
		 ВариантПериода = 10;
		 
		 УстановитьНачальноеОграничение();
	
	КонецЕсли;

КонецПроцедуры // УстановитьПроизвольныйВариантПериода()

// Устанавливает первоначальные значения представления периодов.
// 
&НаСервере
Процедура УстановитьПервоначальныеЗначенияПериодов()

	 ЗначениеПериода = ?(ДатаОкончания = '00010101', ТекущаяДата(), ДатаОкончания);
	 
	 ДатаГод     = КонецГода(ЗначениеПериода);
	 ДатаКвартал = КонецКвартала(ЗначениеПериода);
	 ДатаМесяц   = КонецМесяца(ЗначениеПериода);
	 ДатаДень    = КонецДня(ЗначениеПериода);
	 
КонецПроцедуры // УстановитьПервоначальныеЗначенияПериодов()

// Процедура устанавливет дату начала, дату окончания, вариант периода
// по реквизитам ВариантПериодаФорма, по ограничению начала периода, 
// вызывает процедуру установки интервала.
// 
&НаСервере 
Процедура УстановитьПериод()

	Если ВариантПериодаФорма = 0 Тогда // Год
		
		ДатаНачала    = НачалоГода(ДатаГод);
		ДатаОкончания = КонецГода(ДатаГод);
		
		ВариантПериода = 0; // Год
	
	ИначеЕсли ВариантПериодаФорма = 1 Тогда	// Квартал
				
		ДатаОкончания = КонецКвартала(ДатаКвартал);
		
		Если ПериодСНачалаГода Тогда 		
			ДатаНачала = НачалоГода(ДатаКвартал);
			ВариантПериода = 6; // КварталСНачалаГода
		Иначе
			ДатаНачала    = НачалоКвартала(ДатаКвартал);
			ВариантПериода = 5; // Квартал
		КонецЕсли;
				
	ИначеЕсли ВариантПериодаФорма = 2 Тогда	// Месяц
		
		ДатаОкончания = КонецМесяца(ДатаМесяц);
		                       		
		Если ПериодСНачалаГода Тогда  		
			ДатаНачала = НачалоГода(ДатаМесяц);
			ВариантПериода = 8; // МесяцСНачалаГода
		ИначеЕсли ПериодСНачалаКвартала Тогда 			
			ДатаНачала = НачалоКвартала(ДатаМесяц);
			ВариантПериода = 9; // МесяцСНачалаКвартала
		Иначе
			ДатаНачала    = НачалоМесяца(ДатаМесяц);
		    ВариантПериода = 7; // Месяц
		КонецЕсли;
				
	ИначеЕсли ВариантПериодаФорма = 3 Тогда	// День	
		
		ДатаОкончания = КонецДня(ДатаДень);
		
		Если ПериодСНачалаГода Тогда   		
			ДатаНачала = НачалоГода(ДатаДень);
			ВариантПериода = 2; // ДеньСНачалаГода
		ИначеЕсли ПериодСНачалаКвартала Тогда   			
			ДатаНачала = НачалоКвартала(ДатаДень);
			ВариантПериода = 3; // ДеньСНачалаКвартала
		ИначеЕсли ПериодСНачалаМесяца Тогда	   			
			ДатаНачала = НачалоМесяца(ДатаДень);
			ВариантПериода = 4; // ДеньСНачалаМесяца
		Иначе
			ДатаНачала    = НачалоДня(ДатаДень);
		    ВариантПериода = 1; // День
		КонецЕсли;
			
	ИначеЕсли ВариантПериодаФорма = 4 Тогда	// ПроизвольныйИнтервал
		
		ВариантПериода   = 10;   	
				
	КонецЕсли; 
	
	УстановитьИнтервал();
	 
КонецПроцедуры // УстановитьПериод()

// Процедура устанавливет дату ВариантНачала и ВариантОкончания
// по реквизитам РабочийПериод, ВариантПериодаФорма, по ограничению начала периода.
// 
&НаСервере 
Процедура УстановитьИнтервал()

	Если Не РабочийПериод Тогда
		// ПроизвольныйИнтервал
		ВариантНачала 	 = 7; 
		ВариантОкончания = 7; 
		Возврат;
	КонецЕсли;
	
	Если ВариантПериодаФорма = 0 Тогда // Год
		
		ВариантНачала 	 = 2; // Начало года
		ВариантОкончания = 2; // Конец года
	
	ИначеЕсли ВариантПериодаФорма = 1 Тогда	// Квартал
				
		Если ПериодСНачалаГода Тогда 		
			ВариантНачала  = 2; // Начало года
		Иначе
			ВариантНачала  = 3; // Начало квартала
		КонецЕсли;
		
		ВариантОкончания = 3; // Конец квартала
		
	ИначеЕсли ВариантПериодаФорма = 2 Тогда	// Месяц
		
		Если ПериодСНачалаГода Тогда  		
			ВариантНачала  = 2; // Начало года
		ИначеЕсли ПериодСНачалаКвартала Тогда 			
			ВариантНачала  = 3; // Начало квартала
		Иначе
			ВариантНачала  = 4; // Начало месяца
		КонецЕсли;
		
		ВариантОкончания = 4; // Конец месяца
		
	ИначеЕсли ВариантПериодаФорма = 3 Тогда	// День	
		
		Если ПериодСНачалаГода Тогда   		
			ВариантНачала  = 2; // Начало года
		ИначеЕсли ПериодСНачалаКвартала Тогда   			
			ВариантНачала  = 3; // Начало квартала
		ИначеЕсли ПериодСНачалаМесяца Тогда	   			
			ВариантНачала  = 4; // Начало месяца
		Иначе
			ВариантНачала  = 6; // Начало дня
		КонецЕсли;
		
		ВариантОкончания = 6; // Конец дня
	
	ИначеЕсли ВариантПериодаФорма = 4 Тогда	// ПроизвольныйИнтервал
		
		ВариантНачала 	 = 7; 
		ВариантОкончания = 7;
		
	КонецЕсли; 
 
КонецПроцедуры // УстановитьИнтервал()

// Процедура устанавливет дату ВариантПериода и ВариантПериодаФорма
// по реквизитам ВариантНачала и ВариантОкончания и ограничение начала периода.
// 
&НаСервере 
Процедура УстановитьВариантПериода()

	Если ВариантОкончания = 2 Тогда // Конец года
		
		Если ВариантНачала = 2 Тогда 		// Если Начало года	  			
			ВариантПериода = 0; 				// Год   			
		Иначе	                            // Иначе
			ВариантПериода = 10; 				// ПроизвольныйИнтервал			
		КонецЕсли;
		
		ВариантПериодаФорма = ?(ВариантПериода = 10, 4, 0); // Произвольный интервал(4) или Год(0)
		
	ИначеЕсли ВариантОкончания = 3 Тогда // Конец квартала
		
		Если ВариантНачала = 2 Тогда 		// Если Начало года	  			
			ВариантПериода = 6; 				// КварталСНачалаГода   			
		ИначеЕсли ВариантНачала = 3 Тогда   // Если Начало квартала		
			ВариантПериода = 5; 				// Квартал
		Иначе	                            // Иначе
			ВариантПериода = 10; 				// ПроизвольныйИнтервал			
		КонецЕсли;
		
		ВариантПериодаФорма = ?(ВариантПериода = 10, 4, 1); // Произвольный интервал(4) или Квартал(1)
		
	ИначеЕсли ВариантОкончания = 4 Тогда // Конец месяца
		
		Если ВариантНачала = 2 Тогда 		// Если Начало года	  			
			ВариантПериода = 8; 				// МесяцСНачалаГода   			
		ИначеЕсли ВариантНачала = 3 Тогда   // Если Начало квартала		
			ВариантПериода = 9; 				// МесяцСНачалаКвартала
		ИначеЕсли ВариантНачала = 4 Тогда   // Если Начало месяца
			ВариантПериода = 7; 				// Месяц
		Иначе	                            // Иначе
			ВариантПериода = 10; 				// ПроизвольныйИнтервал			
		КонецЕсли;
		
		ВариантПериодаФорма = ?(ВариантПериода = 10, 4, 2); // Произвольный интервал(4) или Месяц(3)
		
	ИначеЕсли ВариантОкончания = 6 Тогда // Конец дня
		
		Если ВариантНачала = 2 Тогда 		// Если Начало года				
			ВариантПериода = 2; 				// ДеньСНачалаГода  			
		ИначеЕсли ВариантНачала = 3 Тогда 	// Если Начало квартала			
			ВариантПериода = 3; 				// ДеньСНачалаКвартала  			
		ИначеЕсли ВариантНачала = 4 Тогда 	// Если Начало месяца 			
			ВариантПериода = 4; 				// ДеньСНачалаМесяца   			
		ИначеЕсли ВариантНачала = 6 Тогда	// Если Начало дня   			
			ВариантПериода = 1; 	 			// День         			
		Иначе			                    // Иначе
			ВариантПериода = 10; 	 			// ПроизвольныйИнтервал
		КонецЕсли;
		
		ВариантПериодаФорма = ?(ВариантПериода = 10, 4, 3); // Произвольный интервал(4) или День(3)
	
	Иначе
		
		ВариантПериодаФорма = 4; // ПроизвольныйИнтервал
		ВариантПериода = 10; 	 // ПроизвольныйИнтервал
		
	КонецЕсли;
	
	УстановитьНачальноеОграничение();
 
КонецПроцедуры // УстановитьПериод()

// Процедура устанавливает доступность элементов формы.
// 
&НаКлиенте
Процедура УстановитьДоступность()

	Элементы.ДатаНачала.Доступность    = (ВариантНачала    = 7);
	Элементы.ДатаОкончания.Доступность = (ВариантОкончания = 7);
	
	Элементы.СмещениеНачала.Доступность    = (ВариантНачала = 1);
	Элементы.СмещениеОкончания.Доступность = (ВариантОкончания = 1);

	Элементы.ДатаГод.Доступность         		= (НЕ РабочийПериод) И (ВариантПериодаФорма = 0);
	Элементы.ДатаКвартал.Доступность     		= (НЕ РабочийПериод) И (ВариантПериодаФорма = 1);
	Элементы.ПредставлениеДатаМесяц.Доступность = (НЕ РабочийПериод) И (ВариантПериодаФорма = 2);
	Элементы.ДатаДень.Доступность        		= (НЕ РабочийПериод) И (ВариантПериодаФорма = 3);
	
	Элементы.СДатаНачала.Доступность     = (ВариантПериодаФорма = 4);
	Элементы.ПоДатаОкончания.Доступность = (ВариантПериодаФорма = 4);
	
	Элементы.РабочийПериод.Доступность = НЕ (ВариантПериодаФорма = 4);
	
	Если ВариантПериодаФорма = 0 ИЛИ ВариантПериодаФорма = 4 Тогда // Год или произвольный
		
		Элементы.ПериодСНачалаГода.Доступность     = Ложь;
		Элементы.ПериодСНачалаМесяца.Доступность   = Ложь;
		Элементы.ПериодСНачалаКвартала.Доступность = Ложь;
		
	ИначеЕсли ВариантПериодаФорма = 1 Тогда	// Квартал
		
		Элементы.ПериодСНачалаГода.Доступность     = Истина;
		Элементы.ПериодСНачалаМесяца.Доступность   = Ложь;
		Элементы.ПериодСНачалаКвартала.Доступность = Ложь;

	ИначеЕсли ВариантПериодаФорма = 2 Тогда	// Месяц
		
		Элементы.ПериодСНачалаГода.Доступность     = Истина;
		Элементы.ПериодСНачалаКвартала.Доступность = Истина;
		Элементы.ПериодСНачалаМесяца.Доступность   = Ложь;
		
	ИначеЕсли ВариантПериодаФорма = 3 Тогда	// День
		
		Элементы.ПериодСНачалаГода.Доступность     = Истина;
		Элементы.ПериодСНачалаМесяца.Доступность   = Истина;
		Элементы.ПериодСНачалаКвартала.Доступность = Истина;	
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьДоступность()

// Процедура обновляет информационные надписи.
// 
&НаКлиенте
Процедура ОбновитьИнфНадписи()

	ИнформацияОПериоде = "Установлен период: ";
	
	Если (ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания)) 
	   И (ДатаНачала <= ДатаОкончания) Тогда
	   
	   ИнформацияОПериоде = ИнформацияОПериоде + ПредставлениеПериода(ДатаНачала, КонецДня(ДатаОкончания), "ФП");
	   
   ИначеЕсли ЗначениеЗаполнено(ДатаНачала) И НЕ ЗначениеЗаполнено(ДатаОкончания) Тогда
	   
	   ПраваяГраница = '00010101';
	   УстановитьГраницуИнтервала(ВариантНачала, ПраваяГраница, Ложь);
	   
	   Если ЗначениеЗаполнено(ПраваяГраница) Тогда
		   
		   ИнформацияОПериоде = ИнформацияОПериоде + ПредставлениеПериода(ДатаНачала, КонецДня(ПраваяГраница), "ФП");
		   
	   Иначе
		   
		   ИнформацияОПериоде = ИнформацияОПериоде + Формат(ДатаНачала,"ДФ=dd.MM.yyyy") + " - ...";
		   
	   КонецЕсли; 
	   
   ИначеЕсли НЕ ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) Тогда
	   
	   ЛеваяГраница = '00010101';
	   УстановитьГраницуИнтервала(ВариантОкончания, ЛеваяГраница);
	   
	   Если ЗначениеЗаполнено(ЛеваяГраница) Тогда
		   
		   ИнформацияОПериоде = ИнформацияОПериоде + ПредставлениеПериода(ЛеваяГраница, КонецДня(ДатаОкончания), "ФП");
		   
	   Иначе
		   
		   ИнформацияОПериоде = ИнформацияОПериоде + "... - " + Формат(ДатаОкончания,"ДФ=dd.MM.yyyy") ;
		   
	   КонецЕсли;
	   
	Иначе   
	    ИнформацияОПериоде = "Период не установлен"
	КонецЕсли;
	
	ПредставлениеДатаМесяц = Формат(ДатаМесяц, "ДФ='ММММ гггг ""г.""'");
	
КонецПроцедуры // ОбновитьИнфНадписи()

// Процедура устанавливает границу интервала.
// 
&НаКлиенте
Процедура УстановитьГраницуИнтервала(ВариантГраницы, ЗначениеГраницы, ЛеваяГраница = Истина)

	Если ВариантГраницы = 0 Тогда
		
		ЗначениеГраницы = '00010101';
		
	ИначеЕсли ВариантГраницы = 1 Тогда 
		
		ЗначениеГраницы = ТекущаяДата();
		
	ИначеЕсли ВариантГраницы = 2 Тогда
		
		ЗначениеГраницы = ?(ЛеваяГраница, НачалоГода(ТекущаяДата()), КонецГода(ТекущаяДата()));
		
	ИначеЕсли ВариантГраницы = 3 Тогда
		
		ЗначениеГраницы = ?(ЛеваяГраница, НачалоКвартала(ТекущаяДата()), КонецКвартала(ТекущаяДата()));
		
	ИначеЕсли ВариантГраницы = 4 Тогда
		
		ЗначениеГраницы = ?(ЛеваяГраница, НачалоМесяца(ТекущаяДата()), КонецМесяца(ТекущаяДата()));
		
	ИначеЕсли ВариантГраницы = 5 Тогда
		
		ЗначениеГраницы = ?(ЛеваяГраница, НачалоНедели(ТекущаяДата()), КонецНедели(ТекущаяДата()));
		
	ИначеЕсли ВариантГраницы = 6 Тогда
		
		ЗначениеГраницы = ?(ЛеваяГраница, НачалоДня(ТекущаяДата()), КонецДня(ТекущаяДата()));
		
	ИначеЕсли ВариантГраницы = 7 Тогда
		// Ничего не делаем
	КонецЕсли;
	 
КонецПроцедуры // УстановитьГраницуИнтервала()

&НаКлиентеНаСервереБезКонтекста 
Функция ПолучитьСвойствоСтруктуры(Структура, Ключ, Знач Значение = Неопределено) 

	Если Структура.Свойство(Ключ) Тогда
	   Значение = Структура[Ключ];
	КонецЕсли; 

	Возврат Значение;
	
КонецФункции // ПолучитьСвойствоСтруктуры()

#КонецОбласти	
